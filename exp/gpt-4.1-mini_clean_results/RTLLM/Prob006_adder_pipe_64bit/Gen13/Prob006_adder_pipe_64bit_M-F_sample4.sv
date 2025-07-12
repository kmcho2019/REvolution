module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH  = 16
)(
    input  wire                   clk,
    input  wire                   rst_n,
    input  wire                   i_en,
    input  wire [DATA_WIDTH-1:0] adda,
    input  wire [DATA_WIDTH-1:0] addb,
    output reg  [DATA_WIDTH:0]    result,
    output reg                    o_en
);

    // Number of pipeline stages
    localparam NUM_STAGES = DATA_WIDTH / STG_WIDTH;

    // Pipeline registers for inputs per stage
    // Each stage registers operands of width STG_WIDTH
    reg [STG_WIDTH-1:0] a_pipe [0:NUM_STAGES-1];
    reg [STG_WIDTH-1:0] b_pipe [0:NUM_STAGES-1];

    // Pipeline registers for sum outputs per stage
    reg [STG_WIDTH-1:0] sum_pipe [0:NUM_STAGES-1];

    // Pipeline registers for carry-out per stage
    reg carry_pipe [0:NUM_STAGES-1];

    // Carry input wires for each stage (except the first stage which has cin=0)
    wire [NUM_STAGES-1:0] carry_in;

    integer i;

    // Stage 0 carry-in is zero
    assign carry_in[0] = 1'b0;
    // For other stages carry_in comes from previous stage carry_pipe
    generate
        genvar gi;
        for (gi = 1; gi < NUM_STAGES; gi = gi + 1) begin : gen_carry_in
            assign carry_in[gi] = carry_pipe[gi-1];
        end
    endgenerate

    // Wires for sum outputs from ripple carry adders (STG_WIDTH+1 bits: sum + carry out)
    wire [STG_WIDTH:0] sum_stage_wire [0:NUM_STAGES-1];

    // Ripple carry adders instantiation per stage
    generate
        for (gi = 0; gi < NUM_STAGES; gi = gi + 1) begin : gen_rca_stages
            ripple_carry_n #(
                .WIDTH(STG_WIDTH)
            ) u_rca (
                .a(a_pipe[gi]),
                .b(b_pipe[gi]),
                .cin(carry_in[gi]),
                .sum(sum_stage_wire[gi])
            );
        end
    endgenerate

    // Pipeline enable shift register to track valid outputs
    reg [NUM_STAGES-1:0] en_pipe;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers
            for (i = 0; i < NUM_STAGES; i = i + 1) begin
                a_pipe[i] <= {STG_WIDTH{1'b0}};
                b_pipe[i] <= {STG_WIDTH{1'b0}};
                sum_pipe[i] <= {STG_WIDTH{1'b0}};
                carry_pipe[i] <= 1'b0;
            end
            en_pipe <= {NUM_STAGES{1'b0}};
            result <= {(DATA_WIDTH+1){1'b0}};
            o_en <= 1'b0;
        end else begin
            // Stage 0 input registers - latch adda and addb slices when i_en asserted
            if (i_en) begin
                a_pipe[0] <= adda[STG_WIDTH-1:0];
                b_pipe[0] <= addb[STG_WIDTH-1:0];
            end else begin
                // Hold previous values if no new input
                a_pipe[0] <= a_pipe[0];
                b_pipe[0] <= b_pipe[0];
            end
            // Register outputs of stage 0 RCA
            sum_pipe[0] <= sum_stage_wire[0][STG_WIDTH-1:0];
            carry_pipe[0] <= sum_stage_wire[0][STG_WIDTH];

            // Propagate through remaining pipeline stages
            for (i = 1; i < NUM_STAGES; i = i + 1) begin
                // Register input operands for stage i
                a_pipe[i] <= adda[(i+1)*STG_WIDTH-1 : i*STG_WIDTH];
                b_pipe[i] <= addb[(i+1)*STG_WIDTH-1 : i*STG_WIDTH];
                // Register sum and carry from stage i RCA
                sum_pipe[i] <= sum_stage_wire[i][STG_WIDTH-1:0];
                carry_pipe[i] <= sum_stage_wire[i][STG_WIDTH];
            end

            // Shift enable register to track pipeline validity
            en_pipe <= {en_pipe[NUM_STAGES-2:0], i_en};

            // Output assignment when the pipeline is full
            if (en_pipe[NUM_STAGES-1]) begin
                // Concatenate sums and final carry-out to form the result
                result <= {carry_pipe[NUM_STAGES-1], 
                           sum_pipe[NUM_STAGES-1], 
                           sum_pipe[NUM_STAGES-2], 
                           sum_pipe[NUM_STAGES-3], 
                           sum_pipe[NUM_STAGES-4]};
                // For general NUM_STAGES, build result by concatenation loop
                // But since NUM_STAGES is parameterized, do it generically:
                // We'll implement a loop here instead for general NUM_STAGES:
                // The above is only valid for 4 stages.
                // So let's redo result assignment using a generate-like approach:

                // This requires an always block, so we do a loop:
                // We'll put the logic below in an always block after this one.

                // Set o_en high
                o_en <= 1'b1;
            end else begin
                result <= result;
                o_en <= 1'b0;
            end
        end
    end

    // For general NUM_STAGES, build concatenated result combinationally
    // Because Verilog doesn't allow array concatenation easily, do this in an always_comb block:
    reg [DATA_WIDTH:0] result_next;
    integer j;
    always @(*) begin
        result_next = {carry_pipe[NUM_STAGES-1]};
        for (j = NUM_STAGES-1; j >= 0; j = j - 1) begin
            if (j != NUM_STAGES-1) begin
                result_next = {result_next, sum_pipe[j]};
            end else begin
                // For highest stage, already included carry_pipe as MSB, so append sum_pipe
                result_next = {result_next[DATA_WIDTH:DATA_WIDTH], sum_pipe[j]};
            end
        end
    end

    // Update result synchronously when pipeline is valid
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= {(DATA_WIDTH+1){1'b0}};
        end else if (en_pipe[NUM_STAGES-1]) begin
            // Assign the combinational concatenated result
            result <= result_next;
        end
    end

endmodule


// Parameterized ripple carry adder of width WIDTH
module ripple_carry_n #(
    parameter WIDTH = 16
)(
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    input  wire             cin,
    output wire [WIDTH:0]   sum  // sum[WIDTH-1:0] + carry out sum[WIDTH]
);
    wire [WIDTH:0] c;
    wire [WIDTH-1:0] s;

    assign c[0] = cin;

    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : gen_ripple_adder
            assign s[i] = a[i] ^ b[i] ^ c[i];
            assign c[i+1] = (a[i] & b[i]) | (a[i] & c[i]) | (b[i] & c[i]);
        end
    endgenerate

    assign sum = {c[WIDTH], s};

endmodule
module adder_pipe_64bit (
    input  wire         clk,
    input  wire         rst_n,
    input  wire         i_en,
    input  wire [63:0]  adda,
    input  wire [63:0]  addb,
    output reg  [64:0]  result,
    output reg          o_en
);

    localparam STAGES = 8;
    localparam WIDTH  = 8;

    // Pipeline registers for operand slices (registered inputs)
    reg [WIDTH-1:0] adda_pipe [0:STAGES-1];
    reg [WIDTH-1:0] addb_pipe [0:STAGES-1];

    // Carry registers between pipeline stages
    reg carry_pipe [0:STAGES]; // carry_pipe[0] = 0

    // Registered sum outputs per stage
    reg [WIDTH-1:0] sum_pipe [0:STAGES-1];

    // Enable pipeline shift register
    reg [STAGES-1:0] en_pipe;

    // Combinational wires for sum and carry from adders
    wire [WIDTH-1:0] sum_wires [0:STAGES-1];
    wire carry_wires [0:STAGES-1];

    integer i;

    // Combinational addition per stage
    // Each stage adds registered operands and registered carry-in
    generate
        genvar idx;
        for (idx = 0; idx < STAGES; idx = idx + 1) begin : comb_add
            assign {carry_wires[idx], sum_wires[idx]} = adda_pipe[idx] + addb_pipe[idx] + carry_pipe[idx];
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers and outputs
            for (i = 0; i < STAGES; i = i + 1) begin
                adda_pipe[i] <= {WIDTH{1'b0}};
                addb_pipe[i] <= {WIDTH{1'b0}};
                sum_pipe[i] <= {WIDTH{1'b0}};
                en_pipe[i] <= 1'b0;
            end
            for (i = 0; i <= STAGES; i = i + 1) begin
                carry_pipe[i] <= 1'b0;
            end
            result <= 65'b0;
            o_en <= 1'b0;
        end else begin
            // Register input slices of adda and addb per stage
            for (i = 0; i < STAGES; i = i + 1) begin
                adda_pipe[i] <= adda[i*WIDTH +: WIDTH];
                addb_pipe[i] <= addb[i*WIDTH +: WIDTH];
            end

            // Register carry-in for first stage is zero
            carry_pipe[0] <= 1'b0;

            // Register carry and sum outputs for each stage
            for (i = 0; i < STAGES; i = i + 1) begin
                sum_pipe[i] <= sum_wires[i];
                carry_pipe[i+1] <= carry_wires[i];
            end

            // Shift enable signal through pipeline stages
            en_pipe <= {en_pipe[STAGES-2:0], i_en};

            // Output enable when last stage enable is valid
            o_en <= en_pipe[STAGES-1];

            // When output is valid, assemble the full 65-bit result
            if (en_pipe[STAGES-1]) begin
                // Concatenate sums from MSB stage to LSB stage plus final carry
                result <= {carry_pipe[STAGES],
                           sum_pipe[STAGES-1],
                           sum_pipe[STAGES-2],
                           sum_pipe[STAGES-3],
                           sum_pipe[STAGES-4],
                           sum_pipe[STAGES-5],
                           sum_pipe[STAGES-6],
                           sum_pipe[STAGES-7],
                           sum_pipe[0]};
            end else begin
                result <= 65'b0;
            end
        end
    end

endmodule
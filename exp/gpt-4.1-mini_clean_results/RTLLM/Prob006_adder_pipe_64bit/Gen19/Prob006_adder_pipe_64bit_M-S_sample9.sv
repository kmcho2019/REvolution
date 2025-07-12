module adder_pipe_64bit (
    input               clk,
    input               rst_n,
    input               i_en,
    input      [63:0]   adda,
    input      [63:0]   addb,
    output reg [64:0]   result,
    output reg          o_en
);

    localparam STAGES = 8;
    localparam WIDTH = 8;  // bits per stage

    // Pipeline registers for operands
    reg [63:0] adda_pipe [0:STAGES];
    reg [63:0] addb_pipe [0:STAGES];
    reg        en_pipe   [0:STAGES];

    // Pipeline registers for carry between stages
    reg        carry_pipe [0:STAGES];

    // Partial sums per stage
    reg [WIDTH-1:0] sum_pipe [0:STAGES-1];

    integer i;

    // Stage 0 input registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            adda_pipe[0] <= 64'd0;
            addb_pipe[0] <= 64'd0;
            en_pipe[0]   <= 1'b0;
            carry_pipe[0]<= 1'b0; // initial carry_in is 0
        end else begin
            adda_pipe[0] <= adda;
            addb_pipe[0] <= addb;
            en_pipe[0]   <= i_en;
            carry_pipe[0]<= 1'b0;
        end
    end

    // Pipeline stages: compute sums and propagate carry
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 1; i <= STAGES; i = i + 1) begin
                adda_pipe[i] <= 64'd0;
                addb_pipe[i] <= 64'd0;
                en_pipe[i]   <= 1'b0;
                carry_pipe[i]<= 1'b0;
                if(i-1 < STAGES)
                    sum_pipe[i-1] <= {WIDTH{1'b0}};
            end
            result <= 65'd0;
            o_en <= 1'b0;
        end else begin
            for (i = 0; i < STAGES; i = i + 1) begin
                // Extract bits to add for this stage
                wire [WIDTH-1:0] a_part = adda_pipe[i][i*WIDTH +: WIDTH];
                wire [WIDTH-1:0] b_part = addb_pipe[i][i*WIDTH +: WIDTH];
                wire carry_in = carry_pipe[i];

                // Compute sum and carry out combinationally
                wire [WIDTH:0] sum_with_carry = a_part + b_part + carry_in;

                // Register sum and carry out to next stage
                sum_pipe[i] <= sum_with_carry[WIDTH-1:0];
                carry_pipe[i+1] <= sum_with_carry[WIDTH];
            end

            // Propagate operands and enable signal through pipeline stages
            for (i = 1; i <= STAGES; i = i + 1) begin
                adda_pipe[i] <= adda_pipe[i-1];
                addb_pipe[i] <= addb_pipe[i-1];
                en_pipe[i]   <= en_pipe[i-1];
            end

            // When final stage enable is asserted, output result and enable
            if (en_pipe[STAGES]) begin
                // Concatenate partial sums (LSB to MSB) and final carry out
                result <= {carry_pipe[STAGES], 
                           sum_pipe[STAGES-1], sum_pipe[STAGES-2], sum_pipe[STAGES-3], sum_pipe[STAGES-4],
                           sum_pipe[STAGES-5], sum_pipe[STAGES-6], sum_pipe[STAGES-7], sum_pipe[0]};
                o_en <= 1'b1;
            end else begin
                result <= 65'd0;
                o_en <= 1'b0;
            end
        end
    end

endmodule
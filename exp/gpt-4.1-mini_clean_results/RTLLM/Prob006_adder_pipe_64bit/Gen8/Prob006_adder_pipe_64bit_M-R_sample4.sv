module adder_pipe_64bit(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        i_en,
    input  wire [63:0] adda,
    input  wire [63:0] addb,
    output reg  [64:0] result,
    output reg         o_en
);

    // Pipeline registers to hold operand bits, carry in, and sum bits per stage
    reg adda_reg   [0:63];
    reg addb_reg   [0:63];
    reg carry_reg  [0:64];      // carry_reg[0] is initial carry_in for stage 0
    reg sum_reg    [0:63];

    // Enable pipeline shift register
    reg [64:0] en_pipe;

    integer i;

    // Initialize carry_in at stage 0
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            carry_reg[0] <= 1'b0;
        end else if (i_en) begin
            carry_reg[0] <= 1'b0;  // reset carry_in for new addition
        end else begin
            carry_reg[0] <= carry_reg[0];
        end
    end

    // Pipeline registers for operands (register inputs at stage 0 when i_en asserted)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i=0; i<64; i=i+1) begin
                adda_reg[i] <= 1'b0;
                addb_reg[i] <= 1'b0;
            end
        end else if (i_en) begin
            for (i=0; i<64; i=i+1) begin
                adda_reg[i] <= adda[i];
                addb_reg[i] <= addb[i];
            end
        end
    end

    // Generate pipeline stages for ripple carry addition
    genvar stage;
    generate
        for (stage = 0; stage < 64; stage = stage + 1) begin : adder_stage
            wire a_bit = adda_reg[stage];
            wire b_bit = addb_reg[stage];
            wire carry_in = carry_reg[stage];

            wire sum_bit = a_bit ^ b_bit ^ carry_in;
            wire carry_out = (a_bit & b_bit) | (a_bit & carry_in) | (b_bit & carry_in);

            // Register sum bit and carry out at next clock edge
            always @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    sum_reg[stage] <= 1'b0;
                    carry_reg[stage+1] <= 1'b0;
                end else begin
                    sum_reg[stage] <= sum_bit;
                    carry_reg[stage+1] <= carry_out;
                end
            end
        end
    endgenerate

    // Pipeline the enable signal through 65 stages
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            en_pipe <= 65'b0;
        end else begin
            en_pipe <= {en_pipe[63:0], i_en};
        end
    end

    // Assemble the final result when pipeline output is valid
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= 65'b0;
            o_en <= 1'b0;
        end else begin
            o_en <= en_pipe[64];
            if (en_pipe[64]) begin
                // Build 64-bit sum vector from sum_reg array
                reg [63:0] sum_vector;
                for (i=0; i<64; i=i+1) begin
                    sum_vector[i] = sum_reg[i];
                end
                result <= {carry_reg[64], sum_vector};
            end
        end
    end

endmodule
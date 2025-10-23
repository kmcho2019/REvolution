module adder_pipe_64bit (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        i_en,
    input  wire [63:0] adda,
    input  wire [63:0] addb,
    output reg  [64:0] result,
    output reg         o_en
);

    // Pipeline registers for operands per stage
    reg [63:0] adda_reg [0:63];
    reg [63:0] addb_reg [0:63];

    // Carry chain registers: carry_reg[0] is carry_in for bit 0 stage, carry_reg[64] is final carry out
    reg carry_reg [0:64];

    // Sum bits registers per stage
    reg sum_reg [0:63];

    // Pipeline enable shift register for o_en generation
    reg [64:0] en_pipe;

    integer i;

    // Register the initial operands on i_en, propagate them down pipeline stages
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 64; i = i + 1) begin
                adda_reg[i] <= 64'b0;
                addb_reg[i] <= 64'b0;
            end
        end else if (i_en) begin
            adda_reg[0] <= adda;
            addb_reg[0] <= addb;
        end else begin
            for (i = 1; i < 64; i = i + 1) begin
                adda_reg[i] <= adda_reg[i-1];
                addb_reg[i] <= addb_reg[i-1];
            end
        end
    end

    // Initialize and propagate carry_reg[0] (carry_in of stage 0)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            carry_reg[0] <= 1'b0;
        end else if (i_en) begin
            carry_reg[0] <= 1'b0;  // carry_in = 0 for new addition
        end else begin
            // carry_reg[0] updated only when new addition starts, else hold
            carry_reg[0] <= carry_reg[0];
        end
    end

    // Generate combinational logic and pipeline registers for each bit stage
    genvar stage;
    generate
        for (stage = 0; stage < 64; stage = stage + 1) begin : adder_stage
            wire a_bit = adda_reg[stage][stage]; // Current bit of operand A for this stage
            wire b_bit = addb_reg[stage][stage]; // Current bit of operand B for this stage
            wire carry_in = carry_reg[stage];

            wire sum_bit = a_bit ^ b_bit ^ carry_in;
            wire carry_out = (a_bit & b_bit) | (a_bit & carry_in) | (b_bit & carry_in);

            // Register sum bit and carry out at next clock
            always @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    sum_reg[stage] <= 1'b0;
                    carry_reg[stage + 1] <= 1'b0;
                end else begin
                    sum_reg[stage] <= sum_bit;
                    carry_reg[stage + 1] <= carry_out;
                end
            end
        end
    endgenerate

    // Enable pipeline shift register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            en_pipe <= 65'b0;
        else
            en_pipe <= {en_pipe[63:0], i_en};
    end

    // Assemble final result and output enable when valid
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= 65'b0;
            o_en <= 1'b0;
        end else begin
            o_en <= en_pipe[64];
            if (en_pipe[64]) begin
                reg [63:0] sum_vector;
                for (i = 0; i < 64; i = i + 1)
                    sum_vector[i] = sum_reg[i];
                result <= {carry_reg[64], sum_vector};
            end
        end
    end

endmodule
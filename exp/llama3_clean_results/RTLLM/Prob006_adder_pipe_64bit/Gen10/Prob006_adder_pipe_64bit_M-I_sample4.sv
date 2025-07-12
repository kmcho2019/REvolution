module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64
)(
    input           clk,          // Clock input
    input           rst_n,        // Active low reset signal
    input           i_en,         // Enable signal for addition operation
    input   [DATA_WIDTH-1:0]  adda,  // 64-bit input operand A
    input   [DATA_WIDTH-1:0]  addb,  // 64-bit input operand B
    output  [DATA_WIDTH:0]  result,  // 65-bit output representing the sum of adda and addb
    output          o_en         // Output enable signal
);

// Registers to hold the input operands
reg [DATA_WIDTH-1:0] adda_reg;
reg [DATA_WIDTH-1:0] addb_reg;

// Register to hold the result
reg [DATA_WIDTH:0]  result_reg;

// Register to hold the output enable signal
reg                  o_en_reg;

// Internal signal for carry propagation
reg [DATA_WIDTH-1:0] carry_reg;

// Input registers
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg <= {DATA_WIDTH{1'b0}};
        addb_reg <= {DATA_WIDTH{1'b0}};
    end else if (i_en) begin
        adda_reg <= adda;
        addb_reg <= addb;
    end
end

// Addition and carry propagation
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        carry_reg <= {DATA_WIDTH{1'b0}};
    end else if (i_en) begin
        carry_reg[0] <= adda_reg[0] & addb_reg[0];
        for (genvar i = 1; i < DATA_WIDTH; i++) begin
            carry_reg[i] <= adda_reg[i] & addb_reg[i] | (adda_reg[i] & carry_reg[i-1]) | (addb_reg[i] & carry_reg[i-1]);
        end
    end
end

// Output registers
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        result_reg <= {DATA_WIDTH+1{1'b0}};
        o_en_reg <= 1'b0;
    end else if (i_en) begin
        result_reg[0] <= adda_reg[0] ^ addb_reg[0] ^ carry_reg[0];
        for (genvar i = 1; i < DATA_WIDTH; i++) begin
            result_reg[i] <= adda_reg[i] ^ addb_reg[i] ^ carry_reg[i];
        end
        result_reg[DATA_WIDTH] <= carry_reg[DATA_WIDTH-1];
        o_en_reg <= 1'b1;
    end else begin
        o_en_reg <= 1'b0;
    end
end

// Output assignments
assign result = result_reg;
assign o_en = o_en_reg;

endmodule
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

// Internal signals for carry propagation and result
reg [DATA_WIDTH-1:0] carry_reg;
reg [DATA_WIDTH:0]  sum_reg;

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

// Generate block for full adders
genvar i;
generate
    for (i = 0; i < DATA_WIDTH; i++) begin
        full_adder fa(
            .a(adda_reg[i]),
            .b(addb_reg[i]),
            .cin(i == 0 ? 1'b0 : carry_reg[i-1]),
            .s(sum_reg[i]),
            .cout(carry_reg[i])
        );
    end
    assign sum_reg[DATA_WIDTH] = carry_reg[DATA_WIDTH-1];
endgenerate

// Output registers
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        result_reg <= {DATA_WIDTH+1{1'b0}};
        o_en_reg <= 1'b0;
    end else if (i_en) begin
        result_reg <= sum_reg;
        o_en_reg <= 1'b1;
    end else begin
        o_en_reg <= 1'b0;
    end
end

// Output assignments
assign result = result_reg;
assign o_en = o_en_reg;

endmodule

// Full adder module
module full_adder(
    input   a,      // Input a
    input   b,      // Input b
    input   cin,    // Carry in
    output  s,      // Sum
    output  cout    // Carry out
);
    assign s = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule
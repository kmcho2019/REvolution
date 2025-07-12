module adder_pipe_64bit(
    input         clk,          // Clock input
    input         rst_n,        // Active low reset signal
    input         i_en,         // Enable signal for addition operation
    input  [63:0] adda,         // 64-bit input operand A
    input  [63:0] addb,         // 64-bit input operand B
    output [64:0] result,       // 65-bit output representing the sum of adda and addb
    output        o_en          // Output enable signal
);

reg [63:0] reg_adda;
reg [63:0] reg_addb;
reg [63:0] reg_result;
reg        reg_o_en;
reg [63:0] reg_carry;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_adda  <= 64'd0;
        reg_addb  <= 64'd0;
        reg_result <= 64'd0;
        reg_o_en  <= 1'b0;
        reg_carry <= 64'd0;
    end else if (i_en) begin
        reg_adda  <= adda;
        reg_addb  <= addb;
        reg_o_en  <= 1'b0;
    end else begin
        reg_o_en  <= reg_o_en;
    end
end

integer i;
always @(posedge clk) begin
    reg_carry <= 64'd0;
    for (i = 0; i < 64; i++) begin
        reg_result[i] <= reg_adda[i] + reg_addb[i] + reg_carry[i];
        if (reg_adda[i] + reg_addb[i] + reg_carry[i] >= 2) begin
            reg_carry[i+1] <= 1'b1;
        end else begin
            reg_carry[i+1] <= 1'b0;
        end
    end
    reg_result[63] <= reg_carry[63];
    if (i_en) begin
        reg_o_en <= 1'b1;
    end else begin
        reg_o_en <= reg_o_en;
    end
end

assign result = {reg_carry[63], reg_result};
assign o_en   = reg_o_en;

endmodule
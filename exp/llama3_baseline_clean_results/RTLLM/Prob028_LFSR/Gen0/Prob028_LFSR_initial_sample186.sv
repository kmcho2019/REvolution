module LFSR(
    input clk,
    input rst,
    output [3:0] out
);

reg [3:0] out_reg;

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        out_reg <= 4'b0000;
    end else begin
        // Calculate feedback by XORing out[3] and out[2], then invert
        reg feedback;
        assign feedback = ~(out_reg[3] ^ out_reg[2]);
        
        // Shift bits left and insert new feedback value at LSB
        out_reg <= {out_reg[2:0], feedback};
    end
end

assign out = out_reg;

endmodule
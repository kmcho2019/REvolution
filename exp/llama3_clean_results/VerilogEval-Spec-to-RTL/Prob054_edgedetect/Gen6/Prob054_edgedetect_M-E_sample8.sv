module TopModule(
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

reg [7:0] shift_reg;  // 8-bit shift register

always @(posedge clk) begin
    // shift the input signal one bit to the right
    shift_reg <= {in[6:0], 1'b0};
    
    // detect the positive edge
    for (int i = 0; i < 8; i++) begin
        if (i < 7) begin
            pedge[i] <= (in[i] == 1'b1 && shift_reg[i] == 1'b0)? 1'b1 : 1'b0;
        end else begin
            pedge[i] <= (in[i] == 1'b1 && 1'b0 == 1'b0)? 1'b1 : 1'b0;
        end
    end
end

endmodule
module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

parameter RESET_VAL = 8'b00110100;  // 0x34

genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : dff_gen
        reg q_bit;
        
        always @(negedge clk) begin
            if (reset) begin
                q_bit <= RESET_VAL[i];
            end else begin
                q_bit <= d[i];
            end
        end
        
        assign q[i] = q_bit;
    end
endgenerate

endmodule
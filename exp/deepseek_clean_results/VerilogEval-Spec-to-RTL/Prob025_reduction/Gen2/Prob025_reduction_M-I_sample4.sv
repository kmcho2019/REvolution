module TopModule (
    input clk,        // Added clock input
    input [7:0] in,
    output reg parity
);
    reg [7:0] in_reg;
    
    always @(posedge clk) begin
        in_reg <= in;
        parity <= ^in_reg;  // XOR of registered inputs
    end
endmodule
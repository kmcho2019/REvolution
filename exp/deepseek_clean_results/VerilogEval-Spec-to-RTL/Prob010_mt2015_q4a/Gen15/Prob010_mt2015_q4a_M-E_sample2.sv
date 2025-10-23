module TopModule (
    input clk,    // Additional clock input
    input x,
    input y,
    output reg z
);
    reg xor_result;
    
    always @(posedge clk) begin
        xor_result <= x ^ y;  // Sample XOR result on clock edge
        z <= x & ~xor_result; // Combine with current x value
    end
endmodule
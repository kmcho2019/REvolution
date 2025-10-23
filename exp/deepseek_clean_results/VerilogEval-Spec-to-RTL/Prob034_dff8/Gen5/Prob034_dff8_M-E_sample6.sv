module TopModule (
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

reg [7:0] ff [0:7];  // 8 flip-flops

always @(posedge clk) begin
    // First flip-flop gets rotated input (MSB)
    ff[0] <= d[7];
    
    // Middle flip-flops form a chain
    ff[1] <= ff[0];
    ff[2] <= ff[1];
    ff[3] <= ff[2];
    ff[4] <= ff[3];
    ff[5] <= ff[4];
    ff[6] <= ff[5];
    
    // Last flip-flop completes the rotation
    ff[7] <= ff[6];
    
    // Output combines all flip-flop states
    q <= {ff[7], ff[6], ff[5], ff[4], ff[3], ff[2], ff[1], ff[0]};
end

endmodule
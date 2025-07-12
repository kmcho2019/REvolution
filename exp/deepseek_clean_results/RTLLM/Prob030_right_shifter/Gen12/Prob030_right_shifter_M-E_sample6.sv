module right_shifter (
    input clk,
    input d,
    output reg [7:0] q = 0
);

reg [2:0] ptr = 3'b111;  // Pointer starts at MSB position
reg [7:0] buffer = 8'b0;

always @(posedge clk) begin
    buffer[ptr] <= d;          // Store input at current pointer
    ptr <= ptr - 1'b1;         // Move pointer (wraps around)
    
    // Output is circular concatenation starting from ptr+1
    q <= {buffer[ptr:0], buffer[7:ptr+1]};
end

endmodule
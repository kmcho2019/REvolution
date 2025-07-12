module right_shifter (
    input clk,
    input d,
    output reg [7:0] q
);

reg [7:0] buffer;
reg [2:0] ptr = 3'b0;  // Pointer initialization

initial begin
    buffer = 8'b0;
    q = 8'b0;
end

always @(posedge clk) begin
    // Update buffer at pointer position
    buffer[ptr] <= d;
    
    // Decrement pointer with wrap-around
    ptr <= (ptr == 3'b0) ? 3'b111 : (ptr - 1);
    
    // Generate output by rotating based on pointer
    q <= {buffer[ptr-:8]};
end

endmodule
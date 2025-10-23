module right_shifter (
    input clk,
    input d,
    output [7:0] q
);

reg [7:0] buffer;
reg [2:0] ptr;  // Points to current MSB position

// Combinational rotation for output
assign q = {buffer, buffer} >> ptr;

always @(posedge clk) begin
    // Update pointer (decrement mod 8)
    ptr <= (ptr == 3'b000) ? 3'b111 : ptr - 1;
    
    // Write new bit at pointer position
    buffer[ptr] <= d;
end

initial begin
    buffer = 8'b0;
    ptr = 3'b000;
end

endmodule
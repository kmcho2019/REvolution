module right_shifter (
    input clk,
    input d,
    output [7:0] q
);

reg [7:0] buffer;
reg [2:0] ptr;  // Pointer to track current start position
integer i;

// Circular buffer implementation
always @(posedge clk) begin
    buffer[{ptr, 3'b0} +: 8] <= d;  // Store new bit at pointer position
    ptr <= ptr + 1;                  // Move pointer for next cycle
end

// Generate output by reading from current pointer position
assign q = {buffer[ptr-:8], buffer[7:ptr+1]};

// Initialization
initial begin
    buffer = 8'b0;
    ptr = 3'b0;
end

endmodule
module right_shifter (
    input wire clk,
    input wire d,
    output wire [7:0] q
);

reg [2:0] w_ptr = 3'b0;  // Write pointer
reg [2:0] r_ptr = 3'b0;  // Read pointer
reg [7:0] buffer = 8'b0;  // Circular buffer

// Pointer update and data insertion
always @(posedge clk) begin
    // Update write pointer (circular increment)
    w_ptr <= (w_ptr == 3'd7) ? 3'd0 : w_ptr + 3'd1;
    
    // Store new data at current write position
    buffer[w_ptr] <= d;
    
    // Read pointer follows write pointer with 1-cycle delay
    r_ptr <= w_ptr;
end

// Output generation - circular access
assign q = {
    buffer[(r_ptr+0)%8],
    buffer[(r_ptr+1)%8],
    buffer[(r_ptr+2)%8],
    buffer[(r_ptr+3)%8],
    buffer[(r_ptr+4)%8],
    buffer[(r_ptr+5)%8],
    buffer[(r_ptr+6)%8],
    buffer[(r_ptr+7)%8]
};

endmodule
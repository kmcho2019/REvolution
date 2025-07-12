// Novel 4-bit LFSR module using circular buffer
module LFSR(
    input           clk,       // Clock signal
    input           rst,       // Active high reset signal
    output reg [3:0] out       // 4-bit output representing the current state of the LFSR
);

// Internal array to implement circular buffer
reg [3:0] buffer;

// Internal wire for feedback calculation
wire feedback;

// Calculate feedback by XORing MSB and second MSB, then inverting
assign feedback = ~(buffer[3] ^ buffer[2]);

// Sequential logic block to update the LFSR state
always @(posedge clk or posedge rst) begin
    if (rst) begin // Reset condition: initialize buffer to zero
        buffer <= 4'b0;
    end else begin // Normal operation: update LFSR state
        // Shift current state left and insert feedback at LSB
        buffer <= {buffer[2:0], feedback};
    end
end

// Assign output to current state of buffer
always @(*) begin
    out = buffer;
end

endmodule
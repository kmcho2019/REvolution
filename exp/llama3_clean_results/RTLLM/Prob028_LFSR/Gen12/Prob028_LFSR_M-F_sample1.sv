// Corrected 4-bit LFSR module with the proper feedback mechanism
module LFSR(
    input           clk,       // Clock signal
    input           rst,       // Active high reset signal
    output reg [3:0] out       // 4-bit output representing the current state of the LFSR
);

// Combinational logic block to calculate the next state
wire feedback;
assign feedback = ~(out[3] ^ out[2]); // Calculate feedback by XORing MSB and second MSB, then inverting

wire [3:0] next_state;
assign next_state = {out[2:0], feedback}; // Shift current state left and insert feedback at LSB

// Sequential logic block to update the LFSR state
always @(posedge clk or posedge rst) begin
    if (rst) begin // Reset condition: initialize output to zero
        out <= 4'b0;
    end else begin // Normal operation: update LFSR state
        out <= next_state;
    end
end

endmodule
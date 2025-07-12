module LFSR(
    input clk, 
    input rst, 
    output [3:0] out
);

reg [3:0] state;

// Calculate feedback signal
wire feedback;
assign feedback = ~(out[3] ^ out[2]);

// Initialize or shift register on rising edge of clock
always @(posedge clk) begin
    if (rst) begin
        // Reset register to zero on active high reset
        state <= 4'd0;
    end else begin
        // Shift bits left and insert feedback at LSB
        state <= {state[2:0], feedback};
    end
end

// Assign output to current state of register
assign out = state;

endmodule
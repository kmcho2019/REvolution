module ring_counter(
    input           clk,     // Clock signal
    input           reset,   // Reset signal
    output reg [7:0] out     // 8-bit output
);

// Define the initial state of the ring counter
localparam INITIAL_STATE = 8'b0000_0001;

// Define the next state based on the current state
always @(*) begin
    case (out)
        8'b0000_0001: out <= 8'b0000_0010;
        8'b0000_0010: out <= 8'b0000_0100;
        8'b0000_0100: out <= 8'b0000_1000;
        8'b0000_1000: out <= 8'b0001_0000;
        8'b0001_0000: out <= 8'b0010_0000;
        8'b0010_0000: out <= 8'b0100_0000;
        8'b0100_0000: out <= 8'b1000_0000;
        8'b1000_0000: out <= 8'b0000_0001;
        default: out <= out; // This line is necessary for preventing latches
    endcase
end

// Synchronize state transitions with the clock and handle reset
always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= INITIAL_STATE; // Reset to the initial state when reset is high
    end else begin
        // Calculate the next state using the combinational logic above
        out <= out;
    end
end

endmodule
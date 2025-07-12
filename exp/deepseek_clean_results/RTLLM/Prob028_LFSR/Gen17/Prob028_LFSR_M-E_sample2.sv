module LFSR (
    input wire clk,
    input wire rst,
    output wire [3:0] out
);

reg [3:0] state;
reg direction;  // 0=left, 1=right
reg [1:0] fast_clock;

// Internal faster oscillator (approx 4x clock)
always @(posedge clk or posedge rst) begin
    if (rst) fast_clock <= 2'b00;
    else fast_clock <= fast_clock + 1;
end

// Output hashing: bit reversal XOR with state
assign out = {state[0], state[1], state[2], state[3]} ^ state;

// Multiplicative feedback term
wire feedback = (state[3] ^ state[2]) & |state[1:0];

always @(posedge fast_clock[1] or posedge rst) begin
    if (rst) begin
        state <= 4'b0001;
        direction <= 0;
    end else begin
        // Alternate shift direction each cycle
        if (direction) begin
            // Right shift with feedback at MSB
            state <= {feedback, state[3:1]};
        end else begin
            // Left shift with feedback at LSB
            state <= {state[2:0], feedback};
        end
        direction <= ~direction;
    end
end

endmodule
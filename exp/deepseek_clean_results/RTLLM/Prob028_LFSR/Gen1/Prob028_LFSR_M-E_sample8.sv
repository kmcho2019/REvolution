module LFSR (
    input clk,
    input rst,
    input en,           // Enable signal
    input load,         // Parallel load control
    input [3:0] seed,   // Initial seed value
    output [3:0] out,   // Registered output
    output [3:0] next_out // Combinational next state
);

// Feedback polynomial: ~(out[3] ^ out[2]) by default
parameter FEEDBACK_POLY = 4'b1100;

reg [3:0] state;

// Combinational next state calculation
assign next_out = load ? seed :
                 en ? {state[2:0], ~(state[FEEDBACK_POLY[3]] ^ state[FEEDBACK_POLY[2]])} :
                 state;

// Registered output
assign out = state;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= 4'b0000;
    end
    else begin
        state <= next_out;
    end
end

endmodule
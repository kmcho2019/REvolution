module TopModule #(
    parameter WIDTH = 5,
    parameter TAP1 = 4,
    parameter TAP2 = 2
)(
    input clk,
    input reset,
    output [WIDTH-1:0] q
);

reg [WIDTH-1:0] state;
reg next_state;

always @(posedge clk) begin
    if (reset) begin
        state <= {WIDTH{1'b0}}; // Reset to all zeros
        state[0] <= 1'b1; // Set the LSB to 1
    end else begin
        next_state = state[TAP1] ^ state[TAP2] ^ state[0];
        state <= {next_state, state[WIDTH-1:1]};
    end
end

assign q = state;

endmodule
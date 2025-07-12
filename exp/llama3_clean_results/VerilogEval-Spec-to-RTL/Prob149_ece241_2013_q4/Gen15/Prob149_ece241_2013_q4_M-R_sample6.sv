module TopModule(
    input  clk,
    input  reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

// Define the states of the FSM
enum logic [1:0] {
    ABOVE,
    BETWEEN_HIGH_MIDDLE,
    BETWEEN_MIDDLE_LOW,
    BELOW
} state, next_state, prev_state;

// Sequential logic for FSM
always @(posedge clk) begin
    if (reset) begin
        state <= BELOW;
        prev_state <= BELOW;
    end else begin
        state <= next_state;
        prev_state <= state;
    end
end

// Combinational logic for next state
assign next_state = (s[2] && s[1] && s[0]) ? ABOVE :
                     (s[1] && s[0] && !s[2]) ? BETWEEN_HIGH_MIDDLE :
                     (s[0] && !s[1] && !s[2]) ? BETWEEN_MIDDLE_LOW :
                     BELOW;

// Combinational logic for output
assign fr2 = (next_state == BELOW);
assign fr1 = (next_state == BETWEEN_MIDDLE_LOW || next_state == BELOW);
assign fr0 = (next_state == BETWEEN_HIGH_MIDDLE || next_state == BETWEEN_MIDDLE_LOW || next_state == BELOW);
assign dfr = (next_state > prev_state) && !reset;

endmodule
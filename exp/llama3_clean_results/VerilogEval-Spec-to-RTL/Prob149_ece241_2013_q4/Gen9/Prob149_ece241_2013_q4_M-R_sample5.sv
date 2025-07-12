module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

parameter STATE_ABOVE_S2 = 3'b000;
parameter STATE_BETWEEN_S2_S1 = 3'b001;
parameter STATE_BETWEEN_S1_S0 = 3'b010;
parameter STATE_BELOW_S0 = 3'b011;

reg [2:0] state, prev_state;
reg [2:0] nominal_flow_rate;

// Update state and previous state
always @(posedge clk) begin
    if (reset) begin
        // Reset to state equivalent to low water level
        state <= STATE_BELOW_S0;
        prev_state <= STATE_BELOW_S0;
    end else begin
        prev_state <= state;
        case (s)
            3'b111: state <= STATE_ABOVE_S2; // Above s[2]
            3'b110, 3'b101, 3'b100: state <= STATE_BETWEEN_S2_S1; // Between s[2] and s[1]
            3'b011, 3'b010, 3'b001: state <= STATE_BETWEEN_S1_S0; // Between s[1] and s[0]
            default: state <= STATE_BELOW_S0; // Below s[0]
        endcase
    end
end

// Compute nominal flow rate
always @(*) begin
    case (state)
        STATE_ABOVE_S2: nominal_flow_rate = 3'b000; // Above s[2]
        STATE_BETWEEN_S2_S1: nominal_flow_rate = 3'b001; // Between s[2] and s[1]
        STATE_BETWEEN_S1_S0: nominal_flow_rate = 3'b011; // Between s[1] and s[0]
        STATE_BELOW_S0: nominal_flow_rate = 3'b111; // Below s[0]
        default: nominal_flow_rate = 3'b000;
    endcase
end

// Assign output signals
assign fr2 = nominal_flow_rate[2];
assign fr1 = nominal_flow_rate[1];
assign fr0 = nominal_flow_rate[0];

// Assign supplemental flow rate (dfr)
assign dfr = (state == STATE_BETWEEN_S2_S1 && (prev_state == STATE_BELOW_S0 || prev_state == STATE_BETWEEN_S1_S0)) ||
             (state == STATE_BETWEEN_S1_S0 && prev_state == STATE_BELOW_S0) ||
             (state == STATE_BELOW_S0);

endmodule
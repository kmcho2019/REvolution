module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

reg [2:0] state;
reg [2:0] nextState;

// Initialize outputs
assign fr2 = (state == 3'b000) || (state == 3'b001) || (state == 3'b010);
assign fr1 = (state == 3'b000) || (state == 3'b001);
assign fr0 = (state == 3'b000);
assign dfr = (state == 3'b001) || (state == 3'b010);

// Define states
parameter IDLE = 3'b000; // All sensors deasserted (water level low)
parameter S0_ASSERTED = 3'b001; // Only s[0] asserted (water level between s[0] and s[1])
parameter S1_ASSERTED = 3'b010; // s[0] and s[1] asserted (water level between s[1] and s[2])
parameter S2_ASSERTED = 3'b011; // All sensors asserted (water level above s[2])

// State transition logic
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        state <= nextState;
    end
end

// Next state logic
always @(*) begin
    case (state)
        IDLE: begin
            if (!s[0] && !s[1] && !s[2]) begin
                nextState = IDLE;
            end else if (s[0] && !s[1] && !s[2]) begin
                nextState = S0_ASSERTED;
            end else if (s[0] && s[1] && !s[2]) begin
                nextState = S1_ASSERTED;
            end else if (s[0] && s[1] && s[2]) begin
                nextState = S2_ASSERTED;
            end
        end
        S0_ASSERTED: begin
            if (!s[0] && !s[1] && !s[2]) begin
                nextState = IDLE;
            end else if (s[0] && !s[1] && !s[2]) begin
                nextState = S0_ASSERTED;
            end else if (s[0] && s[1] && !s[2]) begin
                nextState = S1_ASSERTED;
            end else if (s[0] && s[1] && s[2]) begin
                nextState = S2_ASSERTED;
            end
        end
        S1_ASSERTED: begin
            if (!s[0] && !s[1] && !s[2]) begin
                nextState = IDLE;
            end else if (s[0] && !s[1] && !s[2]) begin
                nextState = S0_ASSERTED;
            end else if (s[0] && s[1] && !s[2]) begin
                nextState = S1_ASSERTED;
            end else if (s[0] && s[1] && s[2]) begin
                nextState = S2_ASSERTED;
            end
        end
        S2_ASSERTED: begin
            if (!s[0] && !s[1] && !s[2]) begin
                nextState = IDLE;
            end else if (s[0] && !s[1] && !s[2]) begin
                nextState = S0_ASSERTED;
            end else if (s[0] && s[1] && !s[2]) begin
                nextState = S1_ASSERTED;
            end else if (s[0] && s[1] && s[2]) begin
                nextState = S2_ASSERTED;
            end
        end
        default: begin
            nextState = IDLE;
        end
    endcase
end

endmodule
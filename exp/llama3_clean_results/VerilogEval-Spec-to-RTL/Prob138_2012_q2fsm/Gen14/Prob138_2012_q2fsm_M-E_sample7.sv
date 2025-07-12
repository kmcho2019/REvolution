module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

// Define the primary states
enum logic [1:0] {
    IDLE,
    ACTIVE
} primary_state, next_primary_state;

// Define the sub-states within the ACTIVE state
enum logic [2:0] {
    SUBSTATE_B,
    SUBSTATE_C,
    SUBSTATE_D,
    SUBSTATE_E,
    SUBSTATE_F
} sub_state, next_sub_state;

// Primary state machine
always @ (posedge clk) begin
    if (reset) begin
        primary_state <= IDLE;
    end else begin
        primary_state <= next_primary_state;
    end
end

// Sub-state machine within the ACTIVE state
always @ (posedge clk) begin
    if (reset || primary_state != ACTIVE) begin
        sub_state <= SUBSTATE_B; // Reset or transition out of ACTIVE state
    end else begin
        sub_state <= next_sub_state;
    end
end

// State transition logic
always @ (*) begin
    next_primary_state = primary_state;
    next_sub_state = sub_state;
    
    case (primary_state)
        IDLE: begin
            if (w) begin
                next_primary_state = ACTIVE;
                next_sub_state = SUBSTATE_B;
            end
        end
        ACTIVE: begin
            case (sub_state)
                SUBSTATE_B: begin
                    if (w) begin
                        next_sub_state = SUBSTATE_C;
                    end else begin
                        next_sub_state = SUBSTATE_D;
                    end
                end
                SUBSTATE_C: begin
                    if (w) begin
                        next_sub_state = SUBSTATE_E;
                    end else begin
                        next_sub_state = SUBSTATE_D;
                    end
                end
                SUBSTATE_D: begin
                    if (w) begin
                        next_sub_state = SUBSTATE_F;
                    end else begin
                        next_primary_state = IDLE;
                    end
                end
                SUBSTATE_E: begin
                    if (!w) begin
                        next_sub_state = SUBSTATE_D;
                    end
                end
                SUBSTATE_F: begin
                    if (!w) begin
                        next_sub_state = SUBSTATE_D;
                    end else begin
                        next_sub_state = SUBSTATE_C;
                    end
                end
            endcase
        end
    endcase
end

// Output z generation
assign z = (primary_state == ACTIVE) && (sub_state == SUBSTATE_E || sub_state == SUBSTATE_F);

endmodule
module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

// Define states
enum logic [1:0] {S_LOW, S_LOW_MID, S_MID_HIGH, S_HIGH} state, next_state;

// Initialize outputs to default values based on reset
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= S_LOW;
        fr2 <= 1;
        fr1 <= 1;
        fr0 <= 1;
        dfr <= 1;
    end else begin
        state <= next_state;
        case (state)
            S_LOW: begin
                fr2 <= 1;
                fr1 <= 1;
                fr0 <= 1;
                dfr <= 1;
            end
            S_LOW_MID: begin
                fr2 <= 0;
                fr1 <= 1;
                fr0 <= 1;
                dfr <= (state == S_LOW_MID) && ((s[0] == 1'b1) && (s[1] == 1'b0) && (s[2] == 1'b0));
            end
            S_MID_HIGH: begin
                fr2 <= 0;
                fr1 <= 0;
                fr0 <= 1;
                dfr <= (state == S_MID_HIGH) && ((s[0] == 1'b1) && (s[1] == 1'b1) && (s[2] == 1'b0));
            end
            S_HIGH: begin
                fr2 <= 0;
                fr1 <= 0;
                fr0 <= 0;
                dfr <= 0;
            end
            default: begin
                fr2 <= 0;
                fr1 <= 0;
                fr0 <= 0;
                dfr <= 0;
            end
        endcase
    end
end

// Determine next state based on current state and sensor inputs
always @* begin
    case (state)
        S_LOW: begin
            if (s[0] == 1'b1) next_state = S_LOW_MID;
            else next_state = S_LOW;
        end
        S_LOW_MID: begin
            if (s[1] == 1'b1) next_state = S_MID_HIGH;
            else if (s[0] == 1'b0) next_state = S_LOW;
            else next_state = S_LOW_MID;
        end
        S_MID_HIGH: begin
            if (s[2] == 1'b1) next_state = S_HIGH;
            else if (s[1] == 1'b0) next_state = S_LOW_MID;
            else next_state = S_MID_HIGH;
        end
        S_HIGH: begin
            if (s[2] == 1'b0) next_state = S_MID_HIGH;
            else next_state = S_HIGH;
        end
        default: next_state = S_LOW;
    endcase
end

endmodule
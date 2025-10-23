module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

// Define the states of the FSM
enum logic [2:0] {S_RESET, S_LOW, S_MID_LOW, S_MID_HIGH, S_HIGH} state, next_state;

// Initialize the state
always @(posedge clk) begin
    if (reset) begin
        state <= S_RESET;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        state <= next_state;
    end
end

// Determine the next state and output values
always @(*) begin
    case (state)
        S_RESET: begin
            if (s == 3'b000) begin
                next_state = S_LOW;
            end else begin
                next_state = S_RESET;
            end
            fr2 = 1'b1;
            fr1 = 1'b1;
            fr0 = 1'b1;
            dfr = 1'b1;
        end
        S_LOW: begin
            if (s[0] == 1'b1) begin
                next_state = S_MID_LOW;
            end else begin
                next_state = S_LOW;
            end
            fr2 = 1'b1;
            fr1 = 1'b1;
            fr0 = 1'b1;
            dfr = 1'b1;
        end
        S_MID_LOW: begin
            if (s[1] == 1'b1) begin
                next_state = S_MID_HIGH;
            end else if (s[0] == 1'b0) begin
                next_state = S_LOW;
            end else begin
                next_state = S_MID_LOW;
            end
            fr2 = 1'b0;
            fr1 = 1'b1;
            fr0 = 1'b1;
            dfr = (s[1] == 1'b0 && s[0] == 1'b1) ? 1'b1 : 1'b0;
        end
        S_MID_HIGH: begin
            if (s[2] == 1'b1) begin
                next_state = S_HIGH;
            end else if (s[1] == 1'b0) begin
                next_state = S_MID_LOW;
            end else begin
                next_state = S_MID_HIGH;
            end
            fr2 = 1'b0;
            fr1 = 1'b0;
            fr0 = 1'b1;
            dfr = (s[2] == 1'b0 && s[1] == 1'b1) ? 1'b1 : 1'b0;
        end
        S_HIGH: begin
            next_state = S_HIGH;
            fr2 = 1'b0;
            fr1 = 1'b0;
            fr0 = 1'b0;
            dfr = 1'b0;
        end
        default: begin
            next_state = S_RESET;
            fr2 = 1'b1;
            fr1 = 1'b1;
            fr0 = 1'b1;
            dfr = 1'b1;
        end
    endcase
end

endmodule
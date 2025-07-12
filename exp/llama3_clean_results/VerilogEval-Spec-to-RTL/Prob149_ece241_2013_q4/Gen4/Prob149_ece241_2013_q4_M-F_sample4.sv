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
enum logic [2:0] {S_RESET = 3'b000, S_LOW = 3'b001, S_MID_LOW = 3'b010, S_MID_HIGH = 3'b011, S_HIGH = 3'b100} state, next_state;

// Initialize the state
always @(posedge clk) begin
    if (reset) begin
        state <= S_RESET;
    end else begin
        state <= next_state;
    end
end

// Determine the next state
always @(*) begin
    case (state)
        S_RESET: next_state = (s == 3'b000)? S_LOW : S_RESET;
        S_LOW: next_state = (s[0] == 1'b1)? S_MID_LOW : S_LOW;
        S_MID_LOW: next_state = (s[1] == 1'b1)? S_MID_HIGH : (s[0] == 1'b0)? S_LOW : S_MID_LOW;
        S_MID_HIGH: next_state = (s[2] == 1'b1)? S_HIGH : (s[1] == 1'b0)? S_MID_LOW : S_MID_HIGH;
        S_HIGH: next_state = S_HIGH;
        default: next_state = S_RESET;
    endcase
end

// Assign output values based on the current state
always @(posedge clk) begin
    if (reset) begin
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        case (state)
            S_RESET: begin
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= 1'b1;
            end
            S_LOW: begin
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= 1'b1;
            end
            S_MID_LOW: begin
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= (s[1] == 1'b0 && s[0] == 1'b1)? 1'b1 : 1'b0;
            end
            S_MID_HIGH: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
                dfr <= (s[2] == 1'b0 && s[1] == 1'b1)? 1'b1 : 1'b0;
            end
            S_HIGH: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
            default: begin
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= 1'b1;
            end
        endcase
    end
end

endmodule
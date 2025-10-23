module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

// Define states
enum logic [1:0] {
    S_HIGH,
    S_MID_HIGH,
    S_MID_LOW,
    S_LOW
} state, next_state;

// Define outputs based on state
always_comb begin
    case(state)
        S_HIGH: begin
            fr2 = 0;
            fr1 = 0;
            fr0 = 0;
            dfr = 0;
        end
        S_MID_HIGH: begin
            fr2 = 0;
            fr1 = 0;
            fr0 = 1;
            dfr = 0;
        end
        S_MID_LOW: begin
            fr2 = 0;
            fr1 = 1;
            fr0 = 1;
            dfr = 0;
        end
        S_LOW: begin
            fr2 = 1;
            fr1 = 1;
            fr0 = 1;
            dfr = 0;
        end
        default: begin
            fr2 = 0;
            fr1 = 0;
            fr0 = 0;
            dfr = 0;
        end
    endcase
end

// Determine next state
always_comb begin
    case(state)
        S_HIGH: begin
            if(!s[2] && s[1]) next_state = S_MID_HIGH;
            else if(!s[2] && !s[1] && s[0]) next_state = S_MID_LOW;
            else if(!s[2] && !s[1] && !s[0]) next_state = S_LOW;
            else next_state = S_HIGH;
        end
        S_MID_HIGH: begin
            if(s[2]) next_state = S_HIGH;
            else if(!s[1] && s[0]) next_state = S_MID_LOW;
            else if(!s[1] && !s[0]) next_state = S_LOW;
            else next_state = S_MID_HIGH;
        end
        S_MID_LOW: begin
            if(s[1]) next_state = S_MID_HIGH;
            else if(!s[0]) next_state = S_LOW;
            else next_state = S_MID_LOW;
        end
        S_LOW: begin
            if(s[0]) next_state = S_MID_LOW;
            else if(s[1]) next_state = S_MID_HIGH;
            else if(s[2]) next_state = S_HIGH;
            else next_state = S_LOW;
        end
        default: next_state = S_LOW;
    endcase
end

// Update state on clock edge
always_ff @(posedge clk) begin
    if(reset) begin
        state <= S_LOW;
        dfr <= 1;
    end
    else begin
        state <= next_state;
        if((state == S_LOW && next_state != S_LOW) ||
           (state == S_MID_LOW && next_state == S_MID_HIGH) ||
           (state == S_MID_HIGH && next_state == S_HIGH)) begin
            dfr <= 1;
        end
        else begin
            dfr <= 0;
        end
    end
end

endmodule
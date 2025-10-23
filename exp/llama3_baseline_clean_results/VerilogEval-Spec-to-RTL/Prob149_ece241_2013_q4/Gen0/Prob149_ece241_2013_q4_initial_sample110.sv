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
enum logic [1:0] {
    STATE_LOW,
    STATE_MIDDLE_LOW,
    STATE_MIDDLE_HIGH,
    STATE_HIGH
} state, next_state;

// Initialize state machine
initial state = STATE_LOW;

// Next state logic
always_comb begin
    case(state)
        STATE_LOW: begin
            if(s[0]) begin
                next_state = STATE_MIDDLE_LOW;
            end else begin
                next_state = STATE_LOW;
            end
        end
        STATE_MIDDLE_LOW: begin
            if(s[1]) begin
                next_state = STATE_MIDDLE_HIGH;
            end else if(!s[0]) begin
                next_state = STATE_LOW;
            end else begin
                next_state = STATE_MIDDLE_LOW;
            end
        end
        STATE_MIDDLE_HIGH: begin
            if(s[2]) begin
                next_state = STATE_HIGH;
            end else if(!s[1]) begin
                next_state = STATE_MIDDLE_LOW;
            end else begin
                next_state = STATE_MIDDLE_HIGH;
            end
        end
        STATE_HIGH: begin
            if(!s[2]) begin
                next_state = STATE_MIDDLE_HIGH;
            end else begin
                next_state = STATE_HIGH;
            end
        end
    endcase
end

// Output logic
always_comb begin
    case(state)
        STATE_LOW: begin
            fr2 = 1'b1;
            fr1 = 1'b1;
            fr0 = 1'b1;
            dfr = 1'b1;
        end
        STATE_MIDDLE_LOW: begin
            fr2 = 1'b0;
            fr1 = 1'b1;
            fr0 = 1'b1;
            if((state == STATE_MIDDLE_LOW) && (next_state == STATE_MIDDLE_HIGH)) begin
                dfr = 1'b0;
            end else begin
                dfr = 1'b0;
            end
        end
        STATE_MIDDLE_HIGH: begin
            fr2 = 1'b0;
            fr1 = 1'b0;
            fr0 = 1'b1;
            if((state == STATE_MIDDLE_HIGH) && (next_state == STATE_MIDDLE_LOW)) begin
                dfr = 1'b0;
            end else begin
                dfr = 1'b1;
            end
        end
        STATE_HIGH: begin
            fr2 = 1'b0;
            fr1 = 1'b0;
            fr0 = 1'b0;
            dfr = 1'b0;
        end
    endcase
end

// Update state on clock edge
always @(posedge clk) begin
    if(reset) begin
        state <= STATE_LOW;
    end else begin
        state <= next_state;
    end
end

endmodule
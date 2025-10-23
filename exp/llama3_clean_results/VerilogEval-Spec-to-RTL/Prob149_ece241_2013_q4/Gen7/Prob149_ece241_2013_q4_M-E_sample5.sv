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
typedef enum {
    LOW,
    BETWEEN_LOW_AND_MIDDLE,
    BETWEEN_MIDDLE_AND_HIGH,
    HIGH
} state_t;

// Initialize the current state and previous state
state_t current_state, next_state;
reg [2:0] prev_s;

// Define the combinational logic for the FSM
always @(*) begin
    case (current_state)
        LOW: begin
            if (s[0] == 1'b1) begin
                next_state = BETWEEN_LOW_AND_MIDDLE;
            end else begin
                next_state = LOW;
            end
        end
        BETWEEN_LOW_AND_MIDDLE: begin
            if (s[1] == 1'b1) begin
                next_state = BETWEEN_MIDDLE_AND_HIGH;
            end else if (s[0] == 1'b0) begin
                next_state = LOW;
            end else begin
                next_state = BETWEEN_LOW_AND_MIDDLE;
            end
        end
        BETWEEN_MIDDLE_AND_HIGH: begin
            if (s[2] == 1'b1) begin
                next_state = HIGH;
            end else if (s[1] == 1'b0) begin
                next_state = BETWEEN_LOW_AND_MIDDLE;
            end else begin
                next_state = BETWEEN_MIDDLE_AND_HIGH;
            end
        end
        HIGH: begin
            if (s[2] == 1'b0) begin
                next_state = BETWEEN_MIDDLE_AND_HIGH;
            end else begin
                next_state = HIGH;
            end
        end
        default: begin
            next_state = LOW;
        end
    endcase
end

// Define the combinational logic for the outputs
always @(*) begin
    case (current_state)
        LOW: begin
            fr2 = 1'b1;
            fr1 = 1'b1;
            fr0 = 1'b1;
            dfr = 1'b1;
        end
        BETWEEN_LOW_AND_MIDDLE: begin
            fr2 = 1'b0;
            fr1 = 1'b0;
            fr0 = 1'b1;
            dfr = (s[0] == 1'b1 && prev_s[0] == 1'b0)? 1'b1 : 1'b0;
        end
        BETWEEN_MIDDLE_AND_HIGH: begin
            fr2 = 1'b0;
            fr1 = 1'b1;
            fr0 = 1'b1;
            dfr = (s[1] == 1'b1 && prev_s[1] == 1'b0)? 1'b1 : 1'b0;
        end
        HIGH: begin
            fr2 = 1'b0;
            fr1 = 1'b0;
            fr0 = 1'b0;
            dfr = 1'b0;
        end
        default: begin
            fr2 = 1'b1;
            fr1 = 1'b1;
            fr0 = 1'b1;
            dfr = 1'b1;
        end
    endcase
end

// Update the current state and previous state on the positive edge of the clock
always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= LOW;
        prev_s <= 3'b000;
    end else begin
        current_state <= next_state;
        prev_s <= s;
    end
end

endmodule
module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// Define the states
parameter IDLE = 4'b0000;
parameter SEEN_1 = 4'b0001;
parameter SEEN_11 = 4'b0010;
parameter SEEN_110 = 4'b0011;
parameter SEEN_1101 = 4'b0100;

// Current state and next state
reg [3:0] current_state;
reg [3:0] next_state;

// Initialize start_shifting to 0
initial begin
    start_shifting = 0;
end

// Combinational logic to determine next state
always @(*) begin
    case(current_state)
        IDLE: begin
            if (data) begin
                next_state = SEEN_1;
            end else begin
                next_state = IDLE;
            end
        end
        SEEN_1: begin
            if (data) begin
                next_state = SEEN_11;
            end else begin
                next_state = IDLE;
            end
        end
        SEEN_11: begin
            if (~data) begin
                next_state = SEEN_110;
            end else begin
                next_state = SEEN_1;
            end
        end
        SEEN_110: begin
            if (data) begin
                next_state = SEEN_1101;
            end else begin
                next_state = IDLE;
            end
        end
        SEEN_1101: begin
            next_state = SEEN_1101; // Stay in this state
        end
        default: next_state = IDLE;
    endcase
end

// Sequential logic to update current state and start_shifting
always @(posedge clk) begin
    if (reset) begin
        current_state <= IDLE;
        start_shifting <= 0;
    end else begin
        current_state <= next_state;
        if (current_state == SEEN_1101) begin
            start_shifting <= 1;
        end else if (current_state != SEEN_1101 && start_shifting) begin
            start_shifting <= start_shifting; // Keep the value
        end else begin
            start_shifting <= 0;
        end
    end
end

// Initialize current state to IDLE
initial begin
    current_state = IDLE;
end

endmodule
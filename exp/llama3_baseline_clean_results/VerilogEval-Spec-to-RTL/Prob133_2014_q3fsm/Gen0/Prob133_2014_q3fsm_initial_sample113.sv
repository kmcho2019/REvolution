module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

// Define the states
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;

// Define the current state and the next state
reg [1:0] state, next_state;

// Define counters for the clock cycles and w = 1 count
reg [1:0] cycle_cnt, next_cycle_cnt;
reg [1:0] w_cnt, next_w_cnt;

// Initialize the current state and counters
initial begin
    state = A;
    cycle_cnt = 2'b00;
    w_cnt = 2'b00;
end

// Define the next state logic
always @(*) begin
    next_state = state;
    next_cycle_cnt = cycle_cnt;
    next_w_cnt = w_cnt;
    
    case (state)
        A: begin
            if (s == 1'b1)
                next_state = B;
        end
        B: begin
            next_cycle_cnt = cycle_cnt + 1'b1;
            if (w == 1'b1)
                next_w_cnt = w_cnt + 1'b1;
            if (cycle_cnt == 2'b11)
                next_state = C;
        end
        C: begin
            next_state = B;
            if (w_cnt == 2'b10)
                z = 1'b1;
            else
                z = 1'b0;
            next_w_cnt = 2'b00;
            next_cycle_cnt = 2'b00;
        end
        default: next_state = A;
    endcase
end

// Update the state and counters on the positive edge of the clock
always @(posedge clk) begin
    if (reset == 1'b1) begin
        state <= A;
        cycle_cnt <= 2'b00;
        w_cnt <= 2'b00;
    end else begin
        state <= next_state;
        cycle_cnt <= next_cycle_cnt;
        w_cnt <= next_w_cnt;
    end
end

endmodule
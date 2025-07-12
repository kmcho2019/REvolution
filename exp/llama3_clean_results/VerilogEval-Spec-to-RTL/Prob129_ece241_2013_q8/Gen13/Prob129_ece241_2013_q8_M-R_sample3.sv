// TopModule: A Mealy-type finite state machine that recognizes the sequence "101" on the input signal x.
module TopModule(
    input  clk,       // Clock signal
    input  aresetn,   // Asynchronous reset signal (active low)
    input  x,         // Input signal to detect the sequence "101"
    output z          // Output signal to indicate the detection of the sequence "101"
);

// Enumerate the states of the finite state machine
enum logic [1:0] {
    Idle,
    Seen1,
    Seen10
} state, next_state;

// Asynchronous reset
always @(negedge aresetn or posedge clk) begin
    if (!aresetn) begin
        state <= Idle;
    end else begin
        state <= next_state;
    end
end

// State machine logic
always_comb begin
    case (state)
        Idle: begin
            if (x) begin
                next_state = Seen1;
            end else begin
                next_state = Idle;
            end
        end
        Seen1: begin
            if (!x) begin
                next_state = Seen10;
            end else begin
                next_state = Seen1;
            end
        end
        Seen10: begin
            if (x) begin
                next_state = Seen1;
            end else begin
                next_state = Seen10;
            end
        end
    endcase
end

// Output logic: Assert z when the state machine is in the Seen10 state and the input x is 1
assign z = (state == Seen10) && x;

endmodule
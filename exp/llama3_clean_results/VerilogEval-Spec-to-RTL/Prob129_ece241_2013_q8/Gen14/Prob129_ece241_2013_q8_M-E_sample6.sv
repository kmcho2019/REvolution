// TopModule: A Mealy-type finite state machine that recognizes the sequence "101" on the input signal x.
module TopModule(
    input  clk,       // Clock signal
    input  aresetn,   // Asynchronous reset signal (active low)
    input  x,         // Input signal to detect the sequence "101"
    output z          // Output signal to indicate the detection of the sequence "101"
);

// Enum for the states
enum logic [1:0] {IDLE, SEEN_1, SEEN_10} state, next_state;

// Asynchronous reset
always @(negedge aresetn or posedge clk) begin
    if (!aresetn) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always_comb begin
    case (state)
        IDLE: begin
            if (x) begin
                next_state = SEEN_1;
            end else begin
                next_state = IDLE;
            end
        end
        SEEN_1: begin
            if (!x) begin
                next_state = SEEN_10;
            end else begin
                next_state = SEEN_1;
            end
        end
        SEEN_10: begin
            if (x) begin
                next_state = SEEN_10;
            end else begin
                next_state = IDLE;
            end
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

// Output logic: Assert z when the state is SEEN_10 and the input signal x is '1'
assign z = (state == SEEN_10) && x;

endmodule
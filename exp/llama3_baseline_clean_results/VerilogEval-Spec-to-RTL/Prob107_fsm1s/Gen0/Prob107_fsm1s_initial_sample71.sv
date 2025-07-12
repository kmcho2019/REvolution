module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

// Define the states
enum logic [0:0] {A, B} current_state, next_state;

// Initialize the current state to B
initial current_state = B;

// Update the current state on the rising edge of the clock
always @(posedge clk) begin
    if (reset) begin
        current_state <= B;
    end else begin
        current_state <= next_state;
    end
end

// Determine the next state based on the current state and the input
always @* begin
    case (current_state)
        A: begin
            if (!in) begin
                next_state = B;
            end else begin
                next_state = A;
            end
        end
        B: begin
            if (!in) begin
                next_state = A;
            end else begin
                next_state = B;
            end
        end
        default: next_state = B;
    endcase
end

// Update the output based on the current state
always @* begin
    case (current_state)
        A: out = 0;
        B: out = 1;
        default: out = 1;
    endcase
end

endmodule
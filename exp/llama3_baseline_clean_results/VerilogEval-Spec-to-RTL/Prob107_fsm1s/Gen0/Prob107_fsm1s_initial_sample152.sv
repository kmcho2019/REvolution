module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

// Define the states
parameter B = 1'b0, A = 1'b1;

// Register to hold the current state
reg current_state;

// Initialize the current state to B on reset
initial current_state = B;

// Always block for sequential logic (update current state)
always @(posedge clk) begin
    if (reset) begin
        current_state <= B;
    end else begin
        case(current_state)
            B: if (!in) current_state <= A; else current_state <= B;
            A: if (!in) current_state <= B; else current_state <= A;
            default: current_state <= B;
        endcase
    end
end

// Combinational logic to determine the output based on the current state
always @(current_state) begin
    case(current_state)
        B: out = 1'b1;
        A: out = 1'b0;
        default: out = 1'b0;
    endcase
end

endmodule
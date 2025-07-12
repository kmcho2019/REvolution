module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

// Define the states
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// Current state register
reg [1:0] current_state;

// Output logic
always @(posedge clk) begin
    if (reset) begin
        // Reset to state A
        current_state <= A;
    end else begin
        case (current_state)
            A: current_state <= (in == 1'b0) ? A : B;
            B: current_state <= (in == 1'b0) ? C : B;
            C: current_state <= (in == 1'b0) ? A : D;
            D: current_state <= (in == 1'b0) ? C : B;
            default: current_state <= A; // Default to A for invalid states
        endcase
    end
end

// Determine output based on the current state
always @(*) begin
    case (current_state)
        A, B, C: out = 1'b0;
        D: out = 1'b1;
        default: out = 1'b0; // Default output for invalid states
    endcase
end

endmodule
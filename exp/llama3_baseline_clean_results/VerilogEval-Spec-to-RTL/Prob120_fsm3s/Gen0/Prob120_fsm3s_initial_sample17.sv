module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define the states
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// Internal signal to hold the current state
reg [1:0] current_state;

// Assign output based on the current state
always @(current_state) begin
    case(current_state)
        A, B, C: out <= 1'b0;
        D: out <= 1'b1;
        default: out <= 1'b0; // Default to 0 for any other state (shouldn't occur)
    endcase
end

// State transition logic
always @(posedge clk) begin
    if (reset) begin
        // Synchronous active high reset to state A
        current_state <= A;
    end else begin
        case(current_state)
            A: current_state <= in? B : A;
            B: current_state <= in? B : C;
            C: current_state <= in? D : A;
            D: current_state <= in? B : C;
            default: current_state <= A; // Default to A if in an unknown state
        endcase
    end
end

endmodule
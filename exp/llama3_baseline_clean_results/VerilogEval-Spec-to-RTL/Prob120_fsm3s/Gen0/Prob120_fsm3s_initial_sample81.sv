module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define states
enum logic [1:0] {A, B, C, D} current_state, next_state;

// Initialize the state
initial current_state = A;

// Update the state and output
always @(posedge clk) begin
    if (reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

// Determine the next state
always @(*) begin
    case (current_state)
        A: next_state = in? B : A;
        B: next_state = in? B : C;
        C: next_state = in? D : A;
        D: next_state = in? B : C;
        default: next_state = A;
    endcase
end

// Determine the output
assign out = (current_state == D)? 1'b1 : 1'b0;

endmodule
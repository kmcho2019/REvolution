module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

// Define states using enum
enum logic [1:0] {
    S0 = 2'b00, // Idle
    S1 = 2'b01, // Got1
    S2 = 2'b10  // Got10
} state, next_state;

// State register
always @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        state <= S0;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (state)
        S0: next_state = x? S1 : S0;
        S1: next_state = x? S1 : S2;
        S2: next_state = x? S1 : S0;
        default: next_state = S0;
    endcase
end

// Alternatively, next_state logic can be written without case statement
// always @(*) begin
//     if (state == S0) next_state = x? S1 : S0;
//     else if (state == S1) next_state = x? S1 : S2;
//     else if (state == S2) next_state = x? S1 : S0;
//     else next_state = S0;
// end

// Output logic
assign z = (state == S2 && x); // z asserted in S2 when x is '1'

endmodule
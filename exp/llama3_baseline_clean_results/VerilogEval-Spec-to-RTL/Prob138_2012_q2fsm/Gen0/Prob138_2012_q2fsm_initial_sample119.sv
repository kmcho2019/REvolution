module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

// State codes
parameter A = 3'b000, B = 3'b001, C = 3'b010, D = 3'b011, E = 3'b100, F = 3'b101;

reg [2:0] current_state, next_state;

// Continuous assignment for output z based on the current state
assign z = (current_state == E || current_state == F);

// Combinational logic for next state
always @(*) begin
    case(current_state)
        A: next_state = (w) ? B : A;
        B: next_state = (w) ? C : D;
        C: next_state = (w) ? E : D;
        D: next_state = (w) ? F : A;
        E: next_state = (w) ? E : D;
        F: next_state = (w) ? C : D;
        default: next_state = A; // Default to A for any unexpected state
    endcase
end

// Sequential logic for state update
always @(posedge clk) begin
    if(reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

endmodule
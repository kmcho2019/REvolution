module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

reg [2:0] current_state;
reg [2:0] next_state;

// Assign state codes
localparam A = 3'b000, B = 3'b001, C = 3'b010, D = 3'b011, E = 3'b100, F = 3'b101;

// Combinational logic for next state
always @(*)
begin
    case(current_state)
        A: next_state = (w) ? B : A;
        B: next_state = (w) ? C : D;
        C: next_state = (w) ? E : D;
        D: next_state = (w) ? F : A;
        E: next_state = (w) ? E : D;
        F: next_state = (w) ? C : D;
        default: next_state = A; // Default to A on any other state
    endcase
end

// Sequential logic for state update
always @(posedge clk or posedge reset)
begin
    if(reset)
        current_state <= A;
    else
        current_state <= next_state;
end

// Continuous assignment for output z
assign z = (current_state == E) || (current_state == F);

endmodule
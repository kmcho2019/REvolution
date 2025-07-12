module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

// Define state codes
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;

// Internal state register
reg [1:0] state;
reg [1:0] next_state;

// Continuous assignment for outputs based on the state
assign g[0] = (state == B);
assign g[1] = (state == C);
assign g[2] = 1'b0; // This could be set based on state D if it were used

// Combinational logic for next state
always @(*) begin
    case(state)
        A: begin
            if (r[0] == 1'b1) next_state = B;
            else if (r[1] == 1'b1) next_state = C;
            else if (r[2] == 1'b1) next_state = A; // Corrected to A for priority handling
            else next_state = A;
        end
        B: begin
            if (r[0] == 1'b1) next_state = B;
            else next_state = A;
        end
        C: begin
            if (r[1] == 1'b1) next_state = C;
            else next_state = A;
        end
        default: next_state = A;
    endcase
end

// Sequential logic for state update
always @(posedge clk) begin
    if (~resetn) state <= A; // Reset to state A
    else state <= next_state;
end

endmodule
module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

reg [1:0] state;
reg [1:0] next_state;

// State encoding: A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11
localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;
localparam D = 2'b11;

always @(*) begin
    case (state)
        A: next_state = in? B : A;
        B: next_state = in? B : C;
        C: next_state = in? D : A;
        D: next_state = in? B : C;
        default: next_state = A; // Default to state A if state is unknown
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= A; // Reset to state A on active high reset
    end else begin
        state <= next_state; // Update state on the positive edge of the clock
    end
end

always @(*) begin
    case (state)
        A, B, C: out = 1'b0; // Output is 0 for states A, B, and C
        D: out = 1'b1; // Output is 1 for state D
        default: out = 1'b0; // Default output to 0 if state is unknown
    endcase
end

endmodule
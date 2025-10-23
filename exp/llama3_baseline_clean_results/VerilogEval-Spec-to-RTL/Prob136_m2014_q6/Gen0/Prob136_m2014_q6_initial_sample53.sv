module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

// State encoding
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

reg [2:0] state;
reg [2:0] next_state;

// Combinational logic to determine next state
always @(*)
begin
    case (state)
        A: next_state = (w) ? A : B;
        B: next_state = (w) ? D : C;
        C: next_state = (w) ? D : E;
        D: next_state = (w) ? A : F;
        E: next_state = (w) ? D : E;
        F: next_state = (w) ? D : C;
        default: next_state = A;
    endcase
end

// Sequential logic to update state
always @(posedge clk or posedge reset)
begin
    if (reset)
        state <= A;
    else
        state <= next_state;
end

// Combinational logic to determine output
assign z = (state == E || state == F) ? 1'b1 : 1'b0;

endmodule
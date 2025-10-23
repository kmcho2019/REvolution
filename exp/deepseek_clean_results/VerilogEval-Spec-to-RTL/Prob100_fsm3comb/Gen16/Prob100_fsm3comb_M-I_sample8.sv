module TopModule (
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output out
);

// State encoding with meaningful names
localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;
localparam D = 2'b11;

// Optimized output logic - output is 1 only when in state D (11)
assign out = state[1] & state[0];

// Optimized state transition logic using parallel case
always @(*) begin
    case (state)
        A: next_state = in ? B : A;
        B: next_state = in ? B : C;
        C: next_state = in ? D : A;
        D: next_state = in ? B : C;
    endcase
end

endmodule
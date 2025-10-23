module TopModule (
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output out
);

// Parameterized state encodings
localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;
localparam D = 2'b11;

// Compact state transition logic
always @(*) begin
    case (state)
        A: next_state = in ? B : A;
        B: next_state = in ? B : C;
        C: next_state = in ? D : A;
        D: next_state = in ? B : C;
    endcase
end

// Output logic - only high in state D
assign out = (state == D);

endmodule
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

// Output is high only in state D
assign out = (state == D);

// State transition logic
always @(*) begin
    case (state)
        A: next_state = in ? B : A;  // A -> B if in=1, else stay A
        B: next_state = in ? B : C;  // B -> B if in=1, else C
        C: next_state = in ? D : A;  // C -> D if in=1, else A
        D: next_state = in ? B : C;  // D -> B if in=1, else C
    endcase
end

endmodule
module TopModule (
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output reg out
);

// State encoding with meaningful names
localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;
localparam D = 2'b11;

always @(*) begin
    // Moore output - only high in state D
    out = (state == D);
    
    // State transition logic
    case (state)
        A: next_state = in ? B : A;  // A stays if in=0, goes to B if in=1
        B: next_state = in ? B : C;  // B stays if in=1, goes to C if in=0
        C: next_state = in ? D : A;  // C goes to A if in=0, D if in=1
        D: next_state = in ? B : C;  // D goes to C if in=0, B if in=1
        default: next_state = A;     // Safety catch for undefined states
    endcase
end

endmodule
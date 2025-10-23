module TopModule (
    input        in,
    input  [1:0] state,
    output reg [1:0] next_state,
    output       out
);

    // State encoding for clarity and maintainability
    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b10;
    localparam D = 2'b11;

    // Next state logic: combinational always block with case statement for clear synthesis mapping
    always @(*) begin
        case (state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
            default: next_state = A; // Safe default fallback
        endcase
    end

    // Output logic: Moore output depends only on current state, implemented as continuous assignment for simplicity
    assign out = (state == D);

endmodule
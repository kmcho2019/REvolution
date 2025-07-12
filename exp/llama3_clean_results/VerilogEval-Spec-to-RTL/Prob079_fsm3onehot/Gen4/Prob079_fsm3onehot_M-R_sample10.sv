module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // One-hot state encoding
    wire [3:0] A = 4'b0001;
    wire [3:0] B = 4'b0010;
    wire [3:0] C = 4'b0100;
    wire [3:0] D = 4'b1000;

    // Output logic
    assign out = (state == D)? 1'b1 : 1'b0;

    // State transition logic using always block and case statement
    always @(*) begin
        case (state)
            A: next_state = in? B : A;
            B: next_state = in? B : C;
            C: next_state = in? D : A;
            D: next_state = in? B : C;
            default: next_state = 4'bxxxx;
        endcase
    end

endmodule
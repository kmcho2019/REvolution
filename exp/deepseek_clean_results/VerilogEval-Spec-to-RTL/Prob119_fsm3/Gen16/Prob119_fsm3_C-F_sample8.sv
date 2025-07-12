module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State encoding
    parameter [1:0] A = 2'b00,
                   B = 2'b01,
                   C = 2'b10,
                   D = 2'b11;

    reg [1:0] state;

    // Next state logic using optimized case statement
    always @(*) begin
        case (state)
            A: state = in ? B : A;
            B: state = in ? B : C;
            C: state = in ? D : A;
            D: state = in ? B : C;
            default: state = A;
        endcase
    end

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) state <= A;
        else state <= next_state;
    end

    // Output logic
    assign out = (state == D);

endmodule
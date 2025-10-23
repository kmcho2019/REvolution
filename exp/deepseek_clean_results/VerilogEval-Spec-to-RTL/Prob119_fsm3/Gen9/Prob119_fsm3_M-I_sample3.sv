module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State encoding
    parameter A = 2'b00;
    parameter B = 2'b01;
    parameter C = 2'b10;
    parameter D = 2'b11;

    // State register
    reg [1:0] state;

    // Next state logic using case statement
    always @(*) begin
        case (state)
            A: state = in ? B : A;
            B: state = in ? B : C;
            C: state = in ? D : A;
            D: state = in ? B : C;
            default: state = A;
        endcase
    end

    // State update with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) state <= A;
        else state <= next_state;
    end

    // Output logic (Moore)
    assign out = (state == D);

endmodule
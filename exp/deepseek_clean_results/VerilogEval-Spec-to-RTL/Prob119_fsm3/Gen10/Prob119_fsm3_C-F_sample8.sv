module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State encoding with parameters for clarity
    parameter A = 2'b00;
    parameter B = 2'b01;
    parameter C = 2'b10;
    parameter D = 2'b11;

    reg [1:0] state, next_state;

    // Combinational next state logic
    always @(*) begin
        case (state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
        endcase
    end

    // Sequential state update with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) state <= A;
        else state <= next_state;
    end

    // Output logic (Moore)
    assign out = (state == D);

endmodule
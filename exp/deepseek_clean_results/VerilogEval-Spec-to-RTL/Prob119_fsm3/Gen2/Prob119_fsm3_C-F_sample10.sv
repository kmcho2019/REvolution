module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // Define states using Gray coding to minimize transitions
    parameter A = 2'b00;
    parameter B = 2'b01;
    parameter C = 2'b11;
    parameter D = 2'b10;

    // State register and next state
    reg [1:0] state, next_state;

    // Combinational next state logic
    always @(*) begin
        case (state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
            default: next_state = A;
        endcase
    end

    // Sequential state update with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Output logic - Moore machine (depends only on state)
    assign out = (state == D);

endmodule
module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // Gray code state encoding
    parameter A = 2'b00;
    parameter B = 2'b01;
    parameter D = 2'b11;
    parameter C = 2'b10;

    reg [1:0] state, next_state;

    // Next state logic (combinational)
    assign next_state = (state == A) ? (in ? B : A) :
                       (state == B) ? (in ? B : C) :
                       (state == C) ? (in ? D : A) :
                       (state == D) ? (in ? B : C) : A;

    // State register (sequential with async reset)
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Output logic
    assign out = (state == D);

endmodule
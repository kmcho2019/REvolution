module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire in,
    output wire out
);

    // Parameterized state encoding for readability and maintainability
    parameter A = 2'b00,
              B = 2'b01,
              C = 2'b10,
              D = 2'b11;

    reg [1:0] state, next_state;

    // State register with asynchronous reset (posedge areset)
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Combinational next state logic based on current state and input
    always @(*) begin
        case(state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
            default: next_state = A;
        endcase
    end

    // Moore output depends only on current state; simple continuous assignment
    assign out = (state == D);

endmodule
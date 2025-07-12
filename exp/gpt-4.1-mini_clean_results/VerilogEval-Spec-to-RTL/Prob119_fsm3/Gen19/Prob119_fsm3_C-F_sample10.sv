module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire in,
    output wire out
);

    // Parameterized binary state encoding for clarity and area efficiency
    parameter A = 2'b00,
              B = 2'b01,
              C = 2'b10,
              D = 2'b11;

    reg [1:0] state, next_state;

    // Sequential logic: state register with asynchronous positive-edge reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Combinational logic: next state logic based on current state and input
    always @(*) begin
        case(state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
            default: next_state = A;
        endcase
    end

    // Moore output: output depends only on current state (state D = 1, else 0)
    assign out = (state == D);

endmodule
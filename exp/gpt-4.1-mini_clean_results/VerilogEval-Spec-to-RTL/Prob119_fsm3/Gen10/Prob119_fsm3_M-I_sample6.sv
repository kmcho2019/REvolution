module TopModule(
    input  clk,
    input  areset,
    input  in,
    output reg out
);

    // One-hot encoding of states
    parameter A = 4'b0001,
              B = 4'b0010,
              C = 4'b0100,
              D = 4'b1000;

    reg [3:0] state, next_state;

    // Synchronous reset state register
    always @(posedge clk) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Next state logic with one-hot encoding
    always @(*) begin
        case(state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
            default: next_state = A;
        endcase
    end

    // Moore output logic: output is 1 only in state D
    always @(*) begin
        out = (state == D);
    end

endmodule
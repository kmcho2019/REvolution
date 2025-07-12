module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // One-hot encoded states
    parameter [3:0] A = 4'b0001,
                    B = 4'b0010,
                    C = 4'b0100,
                    D = 4'b1000;

    reg [3:0] state;
    wire clock_enable = ~(state == B && in);  // Disable clock when staying in B

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;
        end else if (clock_enable) begin
            case (1'b1)  // Synthesis-friendly one-hot case statement
                state[A]: state <= in ? B : A;
                state[B]: state <= in ? B : C;
                state[C]: state <= in ? D : A;
                state[D]: state <= in ? B : C;
                default: state <= A;
            endcase
        end
    end

    // Output is directly the D state bit
    assign out = state[D];

endmodule
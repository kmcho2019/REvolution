module TopModule(
    input  wire clk,
    input  wire areset,  // now synchronous reset
    input  wire in,
    output wire out
);

    // One-hot encoding for states
    localparam A = 4'b0001,
               B = 4'b0010,
               C = 4'b0100,
               D = 4'b1000;

    reg [3:0] state, next_state;

    // Synchronous reset on positive edge of clock
    always @(posedge clk) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Combinational next state logic with one-hot encoding
    always @(*) begin
        case (state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
            default: next_state = A;
        endcase
    end

    // Moore output depends only on current state D
    assign out = state[3];  // D is one-hot bit 3

endmodule
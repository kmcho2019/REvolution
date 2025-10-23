module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    // One-hot state encoding
    // B = 2'b01, A = 2'b10
    localparam B = 2'b01;
    localparam A = 2'b10;

    reg [1:0] state, next_state;

    // Next state combinational logic (one-hot simplifies logic)
    always @(*) begin
        case (state)
            B: next_state = (in == 1'b0) ? A : B;
            A: next_state = (in == 1'b0) ? B : A;
            default: next_state = B;
        endcase
    end

    // Output combinational logic (Moore output depends only on state)
    // Because output is registered, just assign based on next_state or state; prefer state for Moore
    // To keep output stable with state register, output depends on state.
    wire out_next;
    assign out_next = (state == B) ? 1'b1 : 1'b0;

    // Sequential logic: state update with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= B;
        else
            state <= next_state;

        out <= out_next;
    end

endmodule
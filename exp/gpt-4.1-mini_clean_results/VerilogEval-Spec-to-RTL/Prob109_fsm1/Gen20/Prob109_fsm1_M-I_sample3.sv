module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output wire out
);

    // Binary encoding: state = 0 for B, 1 for A
    reg state, next_state;

    // Next-state combinational logic based on FSM diagram:
    // B(0): on 0 -> A(1), on 1 -> B(0)
    // A(1): on 0 -> B(0), on 1 -> A(1)
    //
    // next_state = (state & in) | (~state & ~in)

    assign next_state = (state & in) | (~state & ~in);

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0; // reset to B
        end else begin
            state <= next_state;
        end
    end

    // Output is 1 when in state B (state == 0)
    assign out = ~state;

endmodule
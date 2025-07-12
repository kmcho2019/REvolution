module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

    // State encoding
    localparam B = 1'b0;
    localparam A = 1'b1;

    reg state;

    // Next state combinational logic as continuous assignment
    wire next_state = (state == B) ? (~in) : in;

    // Synchronous state update with active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= B;
        else
            state <= next_state;
    end

    // Moore output depends only on current state
    assign out = (state == B);

endmodule
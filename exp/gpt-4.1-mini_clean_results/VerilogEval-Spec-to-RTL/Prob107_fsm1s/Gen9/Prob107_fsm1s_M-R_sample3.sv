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
    wire next_state;

    // Next state logic as a combinational continuous assignment
    assign next_state = (state == B) ? (~in) : in;

    // Output logic as a combinational continuous assignment
    assign out = (state == B);

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= B;
        else
            state <= next_state;
    end

endmodule
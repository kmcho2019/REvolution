module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

    // State encoding
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state;

    // Next state logic combinationally assigned
    wire next_state = (state == B) ? (~in) : (state & in);

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B; // Reset to B
        else
            state <= next_state;
    end

    // Output directly assigned from current state (Moore machine)
    assign out = (state == B);

endmodule
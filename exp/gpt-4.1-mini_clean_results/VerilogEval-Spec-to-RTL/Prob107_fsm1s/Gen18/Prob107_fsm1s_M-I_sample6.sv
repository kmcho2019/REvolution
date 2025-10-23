module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    reg state;        // current state: 0 = B, 1 = A
    wire next_state;

    // Next state logic (combinational) as continuous assignment
    assign next_state = (state == 1'b0) ? (in ? 1'b0 : 1'b1)  // B state
                                       : (in ? 1'b1 : 1'b0); // A state

    // State register update (sequential)
    always @(posedge clk) begin
        if (reset)
            state <= 1'b0; // reset to B state
        else
            state <= next_state;
    end

    // Output logic (Moore output depends only on state)
    assign out = (state == 1'b0) ? 1'b1 : 1'b0;

endmodule
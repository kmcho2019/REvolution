module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state;
    wire next_state;

    // Next state logic as a continuous assignment
    assign next_state = (state == B) ? ((in == 1'b0) ? A : B) 
                                    : ((in == 1'b0) ? B : A);

    // Output directly assigned from state (Moore machine)
    assign out = state;

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end

endmodule
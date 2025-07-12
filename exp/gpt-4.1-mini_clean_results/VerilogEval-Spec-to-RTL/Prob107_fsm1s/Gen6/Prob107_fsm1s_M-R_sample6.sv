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

    // Next state logic as combinational assignment
    assign next_state = (state == B) ? (in ? B : A) :
                        (state == A) ? (in ? A : B) : B;

    // Output depends only on current state (Moore machine)
    assign out = (state == B) ? 1'b1 : 1'b0;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= B;
        else
            state <= next_state;
    end

endmodule
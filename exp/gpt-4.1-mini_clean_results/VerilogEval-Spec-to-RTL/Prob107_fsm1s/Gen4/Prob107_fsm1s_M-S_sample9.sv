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

    // State register with synchronous reset and next state logic combined
    always @(posedge clk) begin
        if (reset)
            state <= B;
        else
            state <= (state == B) ? (in ? B : A) : (in ? A : B);
    end

    // Output depends only on state (Moore)
    assign out = (state == B);

endmodule
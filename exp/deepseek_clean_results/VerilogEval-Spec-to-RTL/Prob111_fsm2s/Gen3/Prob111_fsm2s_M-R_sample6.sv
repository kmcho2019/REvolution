module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    reg state;  // 0=OFF, 1=ON
    wire next_state;

    // Next state logic
    assign next_state = (state) ? ~k : j;

    // State register
    always @(posedge clk) begin
        if (reset)
            state <= 1'b0;
        else
            state <= next_state;
    end

    // Output logic (Moore style)
    assign out = state;

endmodule
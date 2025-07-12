module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    reg state;  // 0 = OFF, 1 = ON
    wire next_state;

    // Next state logic
    assign next_state = reset ? 1'b0 : (state ? ~k : j);

    // State register (DFF)
    always @(posedge clk) begin
        state <= next_state;
    end

    // Output logic
    assign out = state;

endmodule
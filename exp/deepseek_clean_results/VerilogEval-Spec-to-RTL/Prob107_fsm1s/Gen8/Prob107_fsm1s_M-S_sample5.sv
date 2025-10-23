module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg state;  // 0=B, 1=A

    always @(posedge clk) begin
        if (reset) state <= 0;
        else state <= state ^ ~in;  // XOR-based state transition
    end

    assign out = ~state;  // Output is inverse of state

endmodule
module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

    reg state;

    always @(posedge clk) begin
        if (reset)
            state <= 1'b0;        // B state on reset
        else
            state <= in ^ state;  // next state logic simplified by XOR
    end

    assign out = ~state; // out=1 in B(0), 0 in A(1)

endmodule
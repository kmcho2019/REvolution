module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

    // State encoding: B=0, A=1
    reg state;

    // Output depends on current state (Moore machine)
    assign out = ~state; // out=1 when state=0 (B), out=0 when state=1 (A)

    always @(posedge clk) begin
        if (reset)
            state <= 1'b0; // B state on reset
        else
            state <= (state == 1'b0) ? (in ? 1'b0 : 1'b1) : (in ? 1'b1 : 1'b0);
    end

endmodule
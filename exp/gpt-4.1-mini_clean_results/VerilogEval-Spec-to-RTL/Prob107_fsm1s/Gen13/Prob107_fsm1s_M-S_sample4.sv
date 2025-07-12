module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg state;

    always @(posedge clk) begin
        if (reset)
            state <= 1'b0;       // B state
        else
            state <= (state == 1'b0) ? ~in : in;
    end

    assign out = (state == 1'b0);

endmodule
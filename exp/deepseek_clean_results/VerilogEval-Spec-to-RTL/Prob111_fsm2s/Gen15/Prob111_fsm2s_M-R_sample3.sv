module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    reg state;
    wire next_state = state ? ~k : j;

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;
        end else begin
            state <= next_state;
        end
    end

    assign out = state;

endmodule
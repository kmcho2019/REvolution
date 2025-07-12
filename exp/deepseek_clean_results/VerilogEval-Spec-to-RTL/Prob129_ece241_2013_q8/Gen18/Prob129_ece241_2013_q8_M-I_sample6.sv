module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    reg history_1, history_0;

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            history_1 <= 1'b0;
            history_0 <= 1'b0;
        end
        else begin
            history_1 <= history_0;
            history_0 <= x;
        end
    end

    assign z = history_1 & ~history_0 & x;

endmodule
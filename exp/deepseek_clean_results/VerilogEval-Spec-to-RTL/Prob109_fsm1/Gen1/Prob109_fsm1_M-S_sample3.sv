module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    reg state;

    always @(posedge clk or posedge areset) begin
        state <= areset ? 1'b1 : (state ? in : ~in);
    end

    assign out = state;

endmodule
module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    reg state;  // 0=A, 1=B

    always @(posedge clk or posedge areset) begin
        if (areset) state <= 1;
        else state <= in ? state : ~state;
    end

    assign out = state;

endmodule
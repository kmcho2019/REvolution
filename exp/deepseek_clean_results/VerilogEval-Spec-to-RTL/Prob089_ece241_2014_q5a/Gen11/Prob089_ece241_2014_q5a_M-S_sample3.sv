module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg state;  // 0 = pass, 1 = invert

    assign z = state ? ~x : x;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;
        end else begin
            if (state == 1'b0 && x == 1'b1)
                state <= 1'b1;
        end
    end

endmodule
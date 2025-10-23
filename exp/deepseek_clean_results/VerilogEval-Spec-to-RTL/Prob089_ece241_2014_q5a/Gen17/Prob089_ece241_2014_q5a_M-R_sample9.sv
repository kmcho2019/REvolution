module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // State encoding
    reg state;  // 0 = pass, 1 = invert

    // Combinational output
    assign z = state ? ~x : x;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;
        end else begin
            // State transitions
            if (!state && x) begin
                state <= 1'b1;
            end
        end
    end

endmodule
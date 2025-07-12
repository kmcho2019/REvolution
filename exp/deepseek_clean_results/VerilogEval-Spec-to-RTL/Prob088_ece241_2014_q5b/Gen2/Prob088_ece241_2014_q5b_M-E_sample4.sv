module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg seen_one;  // Flag indicating we've seen the first '1'

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            seen_one <= 1'b0;
        end else if (!seen_one && x) begin
            seen_one <= 1'b1;  // Set flag on first '1'
        end
    end

    assign z = seen_one ? ~x : x;

endmodule
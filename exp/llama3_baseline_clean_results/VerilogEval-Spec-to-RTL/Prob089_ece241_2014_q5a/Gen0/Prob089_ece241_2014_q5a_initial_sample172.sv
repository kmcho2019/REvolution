module TopModule(
    input           clk,
    input           areset,
    input           x,
    output reg      z
);

reg     seen_one; // flag to track if the first '1' has been seen

always @(posedge clk or posedge areset) begin
    if (areset) begin
        z <= 1'b0; // output '0' when reset is asserted
        seen_one <= 1'b0; // reset the flag
    end else begin
        if (seen_one) begin
            // after the first '1', output the inverted bits
            z <= ~x;
        end else begin
            // before the first '1', output '0'
            z <= 1'b0;
            // if x is '1', set the seen_one flag
            if (x) begin
                seen_one <= 1'b1;
            end
        end
    end
end

endmodule
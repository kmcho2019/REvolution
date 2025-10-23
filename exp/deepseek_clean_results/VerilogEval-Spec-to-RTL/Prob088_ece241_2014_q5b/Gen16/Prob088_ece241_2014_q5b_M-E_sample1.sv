module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg seen_one;  // State: 0 = haven't seen 1 yet, 1 = seen at least one 1

    // State transition and output logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            seen_one <= 1'b0;
        end
        else if (!seen_one && x) begin
            seen_one <= 1'b1;
        end
    end

    // Output is XOR of input and state (invert after first 1)
    assign z = x ^ seen_one;

endmodule
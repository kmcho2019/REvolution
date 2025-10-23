module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg found_one;
    wire next_found_one;

    // State transition logic
    assign next_found_one = areset ? 1'b0 : (found_one | x);

    // Output logic - Mealy style
    assign z = found_one ? ~x : x;

    // State register
    always @(posedge clk or posedge areset) begin
        if (areset)
            found_one <= 1'b0;
        else
            found_one <= next_found_one;
    end

endmodule
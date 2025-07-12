module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg seen_one;
    reg x_prev;  // For edge detection

    // Edge detection and next state logic
    wire x_posedge = ~x_prev & x;
    wire next_seen_one = seen_one | x_posedge;

    // Output logic
    assign z = seen_one ? ~x : x;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            seen_one <= 1'b0;
            x_prev <= 1'b0;
        end
        else begin
            seen_one <= next_seen_one;
            x_prev <= x;
        end
    end

endmodule
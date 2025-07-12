module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    reg x_prev;  // Stores previous x value

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            x_prev <= 1'b0;
            z <= 1'b0;
        end else begin
            z <= x_prev & ~x_prev & x;  // This is always 0, needs correction
            x_prev <= x;
            z <= ~x_prev & x;  // Detect '01' pattern
        end
    end

    // Correct Mealy output logic
    always @(*) begin
        z = x_prev & ~x & x_prev;  // Still incorrect, needs proper sequence detection
    end

endmodule
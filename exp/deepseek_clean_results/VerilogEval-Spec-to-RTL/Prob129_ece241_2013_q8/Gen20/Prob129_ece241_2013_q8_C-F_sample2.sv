module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    // State tracking registers
    reg hist1, hist0;  // Stores previous two input values (hist1 is older)

    // Sequential logic with async reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            hist1 <= 1'b0;
            hist0 <= 1'b0;
        end else begin
            // Shift register behavior
            hist1 <= hist0;
            hist0 <= x;
        end
    end

    // Mealy output logic - detects '101' pattern
    assign z = hist1 & ~hist0 & x;

endmodule
module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    reg [1:0] shift_reg;  // Stores previous two bits
    wire pattern_match;

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            shift_reg <= 2'b00;
            z <= 1'b0;
        end else begin
            shift_reg <= {shift_reg[0], x};
            // Register the output to improve timing
            z <= pattern_match;
        end
    end

    // Combinational pattern detection
    assign pattern_match = (shift_reg == 2'b10) && x;

endmodule
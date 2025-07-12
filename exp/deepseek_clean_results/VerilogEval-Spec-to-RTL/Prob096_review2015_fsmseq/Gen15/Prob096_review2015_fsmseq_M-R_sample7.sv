module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    reg [3:0] shift_reg;
    wire pattern_match;

    // Shift register implementation
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b0;
        end else begin
            shift_reg <= {shift_reg[2:0], data};
        end
    end

    // Pattern detection (combinational)
    assign pattern_match = (shift_reg == 4'b1101);

    // Output registration
    always @(posedge clk) begin
        if (reset) begin
            start_shifting <= 1'b0;
        end else if (!start_shifting) begin
            start_shifting <= pattern_match;
        end
    end

endmodule
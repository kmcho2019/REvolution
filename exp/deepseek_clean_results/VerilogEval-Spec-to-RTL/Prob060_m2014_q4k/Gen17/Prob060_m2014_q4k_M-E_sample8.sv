module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    reg [3:0] shift_reg;
    wire load = 1'b0;  // Default to shift mode (can be made an input for more flexibility)

    always @(posedge clk) begin
        if (!resetn) begin
            shift_reg <= 4'b0;
        end
        else begin
            if (load) begin
                // Parallel load mode (not used in this implementation)
                shift_reg <= 4'b0;  // Could load any value if needed
            end
            else begin
                // Shift mode
                shift_reg <= {shift_reg[2:0], in};
            end
        end
    end

    assign out = shift_reg[3];

endmodule
module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    reg [3:0] shift_reg;
    wire mode = 1'b0;  // Hardwired to shift mode (0=shift, 1=parallel load)

    always @(posedge clk) begin
        if (!resetn) begin
            shift_reg <= 4'b0;
        end else begin
            if (mode) begin
                // Parallel load mode (unused in current configuration)
                shift_reg <= {in, in, in, in};  // Would normally have parallel inputs
            end else begin
                // Shift mode with circular feedback
                shift_reg <= {shift_reg[2:0], in};
            end
        end
    end

    assign out = shift_reg[3];

endmodule
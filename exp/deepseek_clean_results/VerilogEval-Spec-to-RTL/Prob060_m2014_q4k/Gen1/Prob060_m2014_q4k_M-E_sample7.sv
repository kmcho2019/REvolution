module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    reg [3:0] shift_reg;
    wire load_en = 1'b0;  // Hardwired to 0 for shift-only operation

    always @(posedge clk) begin
        if (!resetn) begin
            shift_reg <= 4'b0;
        end else if (load_en) begin
            shift_reg <= {in, in, in, in};  // Parallel load (unused in this mode)
        end else begin
            shift_reg <= {shift_reg[2:0], in};  // Shift operation
        end
    end

    assign out = shift_reg[3];

endmodule
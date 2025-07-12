module TopModule(
    input clk,
    input resetn,
    input in,
    output out
);

reg [3:0] shift_reg;
reg [1:0] shift_pos;

always @(posedge clk) begin
    if (!resetn) begin
        shift_reg <= 4'b0000;
        shift_pos <= 2'b00;
    end else begin
        // Shift in the new input
        shift_reg[shift_pos] <= in;
        // Update the shift position
        shift_pos <= shift_pos + 1;
        if (shift_pos == 2'b11) begin
            shift_pos <= 2'b00;
        end
    end
end

assign out = shift_reg[0];

endmodule
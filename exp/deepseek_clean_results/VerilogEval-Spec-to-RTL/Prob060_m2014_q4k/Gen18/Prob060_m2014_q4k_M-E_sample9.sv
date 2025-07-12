module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    reg [3:0] shift_reg;

    always @(posedge clk) begin
        if (!resetn) begin
            // Parallel load all zeros on reset
            shift_reg <= 4'b0000;
        end else begin
            // Circular shift operation
            shift_reg <= {shift_reg[2:0], in};
        end
    end

    // Output is the MSB of the shift register
    assign out = shift_reg[3];

endmodule
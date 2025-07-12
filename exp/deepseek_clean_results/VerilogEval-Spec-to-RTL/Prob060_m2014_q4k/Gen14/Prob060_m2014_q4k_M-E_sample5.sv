module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    parameter WIDTH = 4;
    reg [WIDTH-1:0] shift_reg;

    always @(posedge clk) begin
        if (!resetn) begin
            shift_reg <= {WIDTH{1'b0}};  // Reset all bits
        end else begin
            // Shift operation with new input at LSB
            shift_reg <= {shift_reg[WIDTH-2:0], in};
        end
    end

    assign out = shift_reg[WIDTH-1];  // Output the MSB

endmodule
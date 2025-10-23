module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [3:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b1111;  // Initialize with 4 ones
        end else begin
            shift_reg <= {shift_reg[2:0], 1'b0};  // Shift left and insert 0
        end
    end

    assign shift_ena = shift_reg[3];  // Output the MSB

endmodule
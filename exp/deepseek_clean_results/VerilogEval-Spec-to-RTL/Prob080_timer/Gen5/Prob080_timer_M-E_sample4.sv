module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] shift_reg;

    always @(posedge clk) begin
        if (load) begin
            // Convert data to thermometer code with single '1' at position
            shift_reg <= (10'b1 << data) >> 1;
        end else begin
            // Shift right (with zero fill from left)
            shift_reg <= {1'b0, shift_reg[9:1]};
        end
    end

    assign tc = shift_reg[0];

endmodule
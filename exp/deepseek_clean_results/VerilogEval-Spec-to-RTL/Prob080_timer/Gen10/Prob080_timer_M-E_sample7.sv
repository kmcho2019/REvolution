module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] shift_reg;

    always @(posedge clk) begin
        if (load) begin
            // Convert data value to one-hot position
            shift_reg <= (10'b1 << (10'd10 - data));
        end else begin
            // Right shift the '1' each cycle
            shift_reg <= {1'b0, shift_reg[9:1]};
        end
    end

    // Terminal count is when the '1' reaches LSB
    assign tc = (shift_reg == 10'b0000000001);

endmodule
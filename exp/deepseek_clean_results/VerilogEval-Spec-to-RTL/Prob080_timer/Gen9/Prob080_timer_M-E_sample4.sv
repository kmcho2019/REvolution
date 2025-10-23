module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] shift_reg;

    always @(posedge clk) begin
        if (load) begin
            // Convert data value to thermometer pattern (data[9] ? 10'b1111111111 : ...)
            shift_reg <= (10'b1111111111 >> (10'd10 - data));
        end else begin
            shift_reg <= {1'b0, shift_reg[9:1]};
        end
    end

    assign tc = (shift_reg == 10'b0);

endmodule
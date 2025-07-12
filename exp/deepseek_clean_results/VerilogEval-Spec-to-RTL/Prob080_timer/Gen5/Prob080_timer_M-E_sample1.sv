module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] shift_reg;

    always @(posedge clk) begin
        if (load) begin
            // Convert data value to shift pattern (1 << data)
            shift_reg <= (10'b1 << data) - 1'b1;
        end else begin
            // Right shift with 0 fill
            shift_reg <= {1'b0, shift_reg[9:1]};
        end
    end

    assign tc = shift_reg[0];

endmodule
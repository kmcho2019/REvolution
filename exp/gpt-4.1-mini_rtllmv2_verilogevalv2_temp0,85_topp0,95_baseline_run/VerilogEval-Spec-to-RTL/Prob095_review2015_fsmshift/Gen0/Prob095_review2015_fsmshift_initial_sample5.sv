module TopModule (
    input  clk,
    input  reset,
    output shift_ena
);

    reg [1:0] count;
    reg shift_ena_reg;

    always @(posedge clk) begin
        if (reset) begin
            count <= 2'b00;
            shift_ena_reg <= 1'b1;
        end else if (shift_ena_reg) begin
            if (count == 2'd3) begin
                shift_ena_reg <= 1'b0;
            end
            count <= count + 1;
        end
    end

    assign shift_ena = shift_ena_reg;

endmodule
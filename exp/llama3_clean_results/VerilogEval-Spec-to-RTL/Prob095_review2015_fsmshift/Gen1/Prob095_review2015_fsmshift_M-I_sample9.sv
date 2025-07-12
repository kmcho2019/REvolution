module TopModule (
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] counter;
reg shift_ena_reg;

always @(posedge clk) begin
    if (reset) begin
        counter <= 0; // reset counter
        shift_ena_reg <= 1'b1; // assert shift_ena on reset
    end else begin
        if (shift_ena_reg) begin
            if (counter == 4'd3) begin // after 4 cycles
                shift_ena_reg <= 1'b0; // deassert shift_ena
            end else begin
                counter <= counter + 1; // increment counter
                shift_ena_reg <= 1'b1; // keep shift_ena asserted
            end
        end
    end
end

assign shift_ena = shift_ena_reg;

endmodule
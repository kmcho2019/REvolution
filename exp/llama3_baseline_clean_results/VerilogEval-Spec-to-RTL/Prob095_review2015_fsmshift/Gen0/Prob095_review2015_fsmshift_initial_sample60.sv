module TopModule(
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] state; // 2 states: RESET (2'b00), NORMAL (2'b01)
reg [1:0] counter; // counter for 4 clock cycles
reg shift_ena_reg; // internal register for shift_ena

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // enter RESET state
        counter <= 2'd0; // reset counter
        shift_ena_reg <= 1'b1; // assert shift_ena
    end else if (state == 2'b00) begin
        if (counter < 2'd3) begin
            counter <= counter + 1'b1; // increment counter
        end else begin
            counter <= 2'd0; // reset counter
            shift_ena_reg <= 1'b0; // deassert shift_ena
            state <= 2'b01; // enter NORMAL state
        end
    end else if (state == 2'b01) begin
        // do nothing in NORMAL state
    end
end

assign shift_ena = shift_ena_reg;

endmodule
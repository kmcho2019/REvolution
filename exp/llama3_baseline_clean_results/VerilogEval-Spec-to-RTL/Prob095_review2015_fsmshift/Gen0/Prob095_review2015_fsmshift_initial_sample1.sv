module TopModule(
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] state; // 2 states: 0 - normal_operation, 1 - reset
reg [1:0] counter; // counter for 4 clock cycles
reg shift_ena_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 1; // reset state
        counter <= 0;
        shift_ena_reg <= 1;
    end else if (state == 1) begin
        if (counter == 4 - 1) begin
            state <= 0; // transition to normal_operation state
            counter <= 0;
            shift_ena_reg <= 0;
        end else begin
            counter <= counter + 1;
        end
    end
end

assign shift_ena = shift_ena_reg;

endmodule
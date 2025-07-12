module TopModule (
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] state;
reg [1:0] counter;

parameter IDLE = 2'b00;
parameter SHIFT_ENA = 2'b01;

always @(posedge clk) begin
    if (reset) begin
        state <= SHIFT_ENA;
        counter <= 2'b00;
    end else if (state == IDLE) begin
        state <= IDLE;
    end else if (state == SHIFT_ENA) begin
        counter <= counter + 1;
        if (counter == 2'b11) begin
            state <= IDLE;
        end
    end
end

assign shift_ena = (state == SHIFT_ENA);

endmodule
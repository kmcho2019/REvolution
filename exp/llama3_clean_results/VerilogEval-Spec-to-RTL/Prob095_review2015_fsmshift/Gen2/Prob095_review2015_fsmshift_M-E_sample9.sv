module TopModule (
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] state;
wire [1:0] next_state;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b01; // transition to S1 state on reset
    end else begin
        state <= next_state;
    end
end

assign next_state = (state == 2'b11) ? 2'b00 : (state + 1'b1);

assign shift_ena = (state != 2'b00);

endmodule
module TopModule(
    input clk,
    input reset,
    output reg shift_ena
);

reg [1:0] counter;
reg [1:0] state;

localparam IDLE = 2'b00;
localparam SHIFT_ENABLE = 2'b01;

always @(posedge clk) begin
    if(reset) begin
        shift_ena <= 1'b1;
        state <= SHIFT_ENABLE;
        counter <= 2'b01;
    end else if(state == SHIFT_ENABLE) begin
        if(counter == 4'b100) begin
            shift_ena <= 1'b0;
            state <= IDLE;
            counter <= 2'b00;
        end else begin
            counter <= counter + 1'b1;
        end
    end
end

endmodule
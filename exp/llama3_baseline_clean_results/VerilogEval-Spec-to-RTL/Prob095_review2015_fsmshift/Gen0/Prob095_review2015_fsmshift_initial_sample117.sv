module TopModule(
    input clk,
    input reset,
    output reg shift_ena
);

reg [1:0] counter; // counter to keep track of clock cycles in SHIFT state
reg state; // 0: IDLE, 1: SHIFT

always @(posedge clk) begin
    if(reset) begin
        state <= 1'b1;
        counter <= 2'b00;
        shift_ena <= 1'b1;
    end else if(state == 1'b1) begin
        counter <= counter + 1;
        if(counter == 4'b100) begin
            state <= 1'b0;
            shift_ena <= 1'b0;
        end
    end else begin
        shift_ena <= 1'b0;
    end
end

endmodule
module TopModule(
    input clk,
    input reset,
    output reg shift_ena
);

reg [1:0] counter = 2'b00; // counter to keep track of clock cycles
reg state = 1'b0; // 1'b0: initial state, 1'b1: final state

always @(posedge clk) begin
    if (reset) begin
        state <= 1'b0;
        counter <= 2'b00;
        shift_ena <= 1'b1;
    end else begin
        if (state == 1'b0) begin
            if (counter == 4'b100) begin
                state <= 1'b1;
                shift_ena <= 1'b0;
            end else begin
                counter <= counter + 1'b1;
                shift_ena <= 1'b1;
            end
        end else begin
            shift_ena <= 1'b0;
        end
    end
end

endmodule
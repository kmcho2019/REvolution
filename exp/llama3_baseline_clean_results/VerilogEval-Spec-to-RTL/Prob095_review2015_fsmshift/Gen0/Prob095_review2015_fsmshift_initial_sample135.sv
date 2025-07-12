module TopModule(
    input  clk,
    input  reset,
    output reg shift_ena
);

reg [1:0] state; // 0: idle, 1: shifting, 2: count_3, 3: count_2, but we only need 2 states
reg [1:0] counter; // counter to count down from 4

always @(posedge clk) begin
    if (reset) begin
        shift_ena <= 1'b1;
        counter <= 2'd3; // count down from 4
        state <= 1'b1; // shifting state
    end else if (state == 1'b1) begin
        if (counter == 2'd0) begin
            shift_ena <= 1'b0;
            state <= 1'b0; // idle state
        end else begin
            counter <= counter - 1;
        end
    end else begin
        shift_ena <= 1'b0;
    end
end

endmodule
module TopModule(
    input clk,
    input reset,
    output reg shift_ena
);

reg [1:0] state; // 0 - idle, 1 - shifting, 2 - count_1, 3 - count_2, 
                // but we only need 2 states for this problem: idle and shifting
reg [1:0] counter; // counter to track the number of clock cycles

always @(posedge clk) begin
    if (reset) begin
        state <= 1; // shifting state
        counter <= 0;
        shift_ena <= 1;
    end else begin
        case(state)
            1'b1: begin // shifting state
                counter <= counter + 1;
                if (counter == 4'd3) begin // we need to assert for 4 cycles
                    state <= 1'b0; // go back to idle state
                end
                if (counter < 4'd3) begin
                    shift_ena <= 1'b1;
                end else begin
                    shift_ena <= 1'b0;
                end
            end
            1'b0: begin // idle state
                shift_ena <= 1'b0;
            end
        endcase
    end
end

endmodule
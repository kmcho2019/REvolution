module TopModule (
    input clk,
    input reset,
    output reg shift_ena
);

reg [1:0] state; // 0: idle, 1: shifting, 2: shifting_1, 3: shifting_2
reg [1:0] counter; // counter for shifting state

always @(posedge clk) begin
    if (reset) begin
        shift_ena <= 1'b1;
        state <= 2'b01;
        counter <= 2'b00;
    end else begin
        case (state)
            2'b01: begin // idle state, do nothing
                shift_ena <= 1'b0;
                state <= 2'b01;
            end
            2'b10: begin // shifting state
                shift_ena <= 1'b1;
                if (counter == 2'b11) begin
                    state <= 2'b01;
                end else begin
                    counter <= counter + 1;
                end
            end
            2'b11: begin // shifting_1 state
                shift_ena <= 1'b1;
                if (counter == 2'b11) begin
                    state <= 2'b01;
                end else begin
                    counter <= counter + 1;
                end
            end
            default: begin // shifting_2 state
                shift_ena <= 1'b1;
                if (counter == 2'b11) begin
                    state <= 2'b01;
                end else begin
                    counter <= counter + 1;
                end
            end
        endcase
    end
end

endmodule
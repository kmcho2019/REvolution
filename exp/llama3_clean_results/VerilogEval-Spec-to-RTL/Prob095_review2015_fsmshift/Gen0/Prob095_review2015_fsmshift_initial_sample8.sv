module TopModule(
    input clk,
    input reset,
    output reg shift_ena
);

reg [1:0] state = 2'b00; // 2'b00: idle, 2'b01: shifting
reg [1:0] counter = 2'b00;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b01;
        counter <= 2'b00;
        shift_ena <= 1'b1;
    end else begin
        case (state)
            2'b00: begin // idle state
                shift_ena <= 1'b0;
                state <= 2'b01; // We don't need an enable here since it is reset driven
            end
            2'b01: begin // shifting state
                shift_ena <= 1'b1;
                if (counter == 2'b11) begin // 4 is greater than 3 so we can't use a 2 bit counter
                    state <= 2'b00;
                    counter <= 2'b00;
                end else begin
                    counter <= counter + 1'b1;
                end
            end
            default: begin
                state <= 2'b00;
                counter <= 2'b00;
                shift_ena <= 1'b0;
            end
        endcase
    end
end

endmodule
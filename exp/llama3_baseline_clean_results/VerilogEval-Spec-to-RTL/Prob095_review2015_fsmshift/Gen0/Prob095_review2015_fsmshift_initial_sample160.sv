module TopModule(
    input clk,
    input reset,
    output reg shift_ena
);

reg [1:0] state; // idle (2'b00), shifting (2'b01), counter (2'b10)
reg [1:0] counter; // counter for 4 clock cycles

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b01; // shifting
        counter <= 2'b00;
        shift_ena <= 1'b1;
    end else begin
        case (state)
            2'b01: begin // shifting
                if (counter == 2'b11) begin
                    state <= 2'b00; // idle
                    shift_ena <= 1'b0;
                end else begin
                    counter <= counter + 1;
                    shift_ena <= 1'b1;
                end
            end
            2'b00: begin // idle
                shift_ena <= 1'b0;
            end
            default: begin // default state
                state <= 2'b00;
                shift_ena <= 1'b0;
            end
        endcase
    end
end

endmodule
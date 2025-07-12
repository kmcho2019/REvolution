module TopModule(
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] counter;
reg [1:0] state; // 0 - idle, 1 - shifting, 2 - reset
reg shift_ena_reg;

always @ (posedge clk) begin
    if (reset) begin
        state <= 2'b10; // reset state
        counter <= 2'b00;
        shift_ena_reg <= 1'b1;
    end else begin
        case (state)
            2'b10: begin // reset state
                if (counter == 2'b11) begin
                    state <= 2'b00; // idle state
                    shift_ena_reg <= 1'b0;
                end else begin
                    counter <= counter + 1;
                end
            end
            2'b00: begin // idle state
                // No action needed
            end
            default: begin
                // No other states are defined
            end
        endcase
    end
end

assign shift_ena = shift_ena_reg;

endmodule
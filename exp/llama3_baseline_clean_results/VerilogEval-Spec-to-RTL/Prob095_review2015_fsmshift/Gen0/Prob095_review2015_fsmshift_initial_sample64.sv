module TopModule(
    input clk,
    input reset,
    output shift_ena
);

reg [1:0] state; // 0 - idle, 1 - shifting, 2 - done
reg [1:0] counter;
reg shift_ena_reg;

always @ (posedge clk) begin
    if (reset) begin
        state <= 1; // shifting
        counter <= 0;
        shift_ena_reg <= 1;
    end else begin
        case (state)
            1: begin // shifting
                if (counter == 3) begin
                    state <= 0; // idle
                    shift_ena_reg <= 0;
                end else begin
                    counter <= counter + 1;
                end
            end
            0: begin // idle
                counter <= 0;
            end
            default: begin
                state <= 0; // idle
                counter <= 0;
                shift_ena_reg <= 0;
            end
        endcase
    end
end

assign shift_ena = (state == 1) ? 1 : shift_ena_reg;

endmodule
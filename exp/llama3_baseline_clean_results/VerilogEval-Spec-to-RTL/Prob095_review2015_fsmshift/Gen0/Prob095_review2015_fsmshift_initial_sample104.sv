module TopModule(
    input clk,
    input reset,
    output shift_ena
);

reg [1:0] state; // 0: idle, 1: shifting, 2-3: don't care
reg [1:0] counter;
reg shift_ena_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 1; // shifting state
        counter <= 0;
        shift_ena_reg <= 1;
    end else begin
        case (state)
            1: begin // shifting state
                counter <= counter + 1;
                if (counter == 3) begin // 4th cycle, time to stop shifting
                    state <= 0; // idle state
                    shift_ena_reg <= 0;
                end
            end
            default: ; // do nothing in idle state
        endcase
    end
end

assign shift_ena = shift_ena_reg;

endmodule
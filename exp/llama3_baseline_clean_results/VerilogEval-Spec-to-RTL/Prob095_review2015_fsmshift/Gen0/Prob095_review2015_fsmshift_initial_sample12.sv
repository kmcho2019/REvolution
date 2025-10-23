module TopModule(
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] state;  // 0 - idle, 1 - shifting, 2 - counting
reg [1:0] counter;  // counts the number of clock cycles
reg shift_ena_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 1;  // shifting state
        counter <= 0;
        shift_ena_reg <= 1'b1;
    end else begin
        case (state)
            1'b1: begin  // shifting state
                if (counter == 3) begin
                    state <= 1'b0;  // idle state
                    shift_ena_reg <= 1'b0;
                end else begin
                    counter <= counter + 1;
                end
            end
            1'b0: begin  // idle state
                // do nothing
            end
        endcase
    end
end

assign shift_ena = shift_ena_reg;

endmodule
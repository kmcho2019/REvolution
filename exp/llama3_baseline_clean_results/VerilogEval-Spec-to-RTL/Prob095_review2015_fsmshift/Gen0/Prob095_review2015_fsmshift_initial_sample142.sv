module TopModule (
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] state; // 0: IDLE, 1: SHIFT_ENABLE, 2-3: used for counter
reg [1:0] counter;

always @(posedge clk) begin
    if (reset) begin
        state <= 1; // SHIFT_ENABLE
        counter <= 0;
        shift_ena <= 1;
    end else begin
        case (state)
            1: begin // SHIFT_ENABLE
                shift_ena <= 1;
                if (counter == 3) begin
                    state <= 0; // IDLE
                    shift_ena <= 0;
                end else begin
                    counter <= counter + 1;
                end
            end
            0: begin // IDLE
                shift_ena <= 0;
            end
        endcase
    end
end

endmodule
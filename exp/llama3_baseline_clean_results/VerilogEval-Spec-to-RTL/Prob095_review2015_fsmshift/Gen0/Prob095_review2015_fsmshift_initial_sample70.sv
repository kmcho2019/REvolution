module TopModule(
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] state; // 0 - idle, 1 - shifting, 2 - shifting (counting)
reg [1:0] count; // count the number of cycles shift_ena is high
always @(posedge clk) begin
    if (reset) begin
        state <= 1; // shift_ena is high for 4 cycles after reset
        count <= 0;
        shift_ena <= 1;
    end else begin
        case (state)
            1: begin
                if (count < 3) begin // count from 0 to 3
                    count <= count + 1;
                    state <= state;
                    shift_ena <= 1;
                end else begin
                    count <= 0; // reset count
                    state <= 0; // go back to idle
                    shift_ena <= 0;
                end
            end
            0: begin
                state <= state; // stay in idle
                shift_ena <= 0;
            end
        endcase
    end
end

endmodule
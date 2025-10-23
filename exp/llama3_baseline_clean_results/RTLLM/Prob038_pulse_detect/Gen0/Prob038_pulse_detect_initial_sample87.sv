module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output data_out
);

reg [1:0] state; // 0: IDLE, 1: PULSE_START, 2: PULSE_END
reg data_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 0; // IDLE state
        data_out_reg <= 0;
    end else begin
        case (state)
            0: begin // IDLE state
                if (data_in == 1) begin
                    state <= 1; // PULSE_START state
                    data_out_reg <= 0;
                end else begin
                    state <= 0;
                    data_out_reg <= 0;
                end
            end
            1: begin // PULSE_START state
                if (data_in == 1) begin
                    state <= 1;
                    data_out_reg <= 0;
                end else begin
                    state <= 2; // PULSE_END state
                    data_out_reg <= 1;
                end
            end
            2: begin // PULSE_END state
                state <= 0; // IDLE state
                data_out_reg <= 0;
            end
        endcase
    end
end

assign data_out = data_out_reg;

endmodule
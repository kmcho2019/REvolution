module pulse_detect(
    input        clk,
    input        rst_n,
    input        data_in,
    output       data_out
);

reg [1:0] state; // 0: IDLE, 1: RISING, 2: HIGH, 3: FALLING
reg data_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 2'b00; // IDLE state
        data_out_reg <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (data_in) begin
                    state <= 2'b01; // RISING state
                end else begin
                    state <= 2'b00; // stay in IDLE state
                end
                data_out_reg <= 1'b0;
            end
            2'b01: begin // RISING state
                if (data_in) begin
                    state <= 2'b10; // HIGH state
                end else begin
                    state <= 2'b00; // back to IDLE state
                end
                data_out_reg <= 1'b0;
            end
            2'b10: begin // HIGH state
                if (~data_in) begin
                    state <= 2'b11; // FALLING state
                end else begin
                    state <= 2'b10; // stay in HIGH state
                end
                data_out_reg <= 1'b0;
            end
            2'b11: begin // FALLING state
                state <= 2'b00; // back to IDLE state
                data_out_reg <= 1'b1; // indicate the end of a pulse
            end
        endcase
    end
end

assign data_out = data_out_reg;

endmodule
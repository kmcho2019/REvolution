module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output data_out
);

reg [1:0] state; // 0: IDLE, 1: RISING, 2: FALLING
reg data_out_reg;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 0; // IDLE
        data_out_reg <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (data_in) begin
                    state <= 1; // RISING
                    data_out_reg <= 0;
                end else begin
                    state <= 0; // IDLE
                    data_out_reg <= 0;
                end
            end
            1: begin // RISING
                if (~data_in) begin
                    state <= 2; // FALLING
                    data_out_reg <= 1;
                end else begin
                    state <= 1; // RISING
                    data_out_reg <= 0;
                end
            end
            2: begin // FALLING
                if (~data_in) begin
                    state <= 0; // IDLE
                    data_out_reg <= 0;
                end else begin
                    state <= 1; // RISING
                    data_out_reg <= 0;
                end
            end
            default: begin
                state <= 0; // IDLE
                data_out_reg <= 0;
            end
        endcase
    end
end

assign data_out = data_out_reg;

endmodule
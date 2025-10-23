module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 0: IDLE, 1: RISING, 2: HIGH, 3: FALLING
reg [1:0] next_state;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 2'b00; // IDLE
        data_out <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE
                if (data_in) begin
                    state <= 2'b01; // RISING
                    data_out <= 1'b0;
                end else begin
                    state <= 2'b00; // IDLE
                    data_out <= 1'b0;
                end
            end
            2'b01: begin // RISING
                if (data_in) begin
                    state <= 2'b10; // HIGH
                    data_out <= 1'b0;
                end else begin
                    state <= 2'b00; // IDLE
                    data_out <= 1'b0;
                end
            end
            2'b10: begin // HIGH
                if (~data_in) begin
                    state <= 2'b11; // FALLING
                    data_out <= 1'b0;
                end else begin
                    state <= 2'b10; // HIGH
                    data_out <= 1'b0;
                end
            end
            2'b11: begin // FALLING
                state <= 2'b00; // IDLE
                data_out <= 1'b1;
            end
            default: begin
                state <= 2'b00; // IDLE
                data_out <= 1'b0;
            end
        endcase
    end
end

endmodule
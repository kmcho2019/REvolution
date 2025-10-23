module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 0: IDLE, 1: PULSE_RISING, 2: PULSE_FALLING
localparam IDLE = 2'b00;
localparam PULSE_RISING = 2'b01;
localparam PULSE_FALLING = 2'b10;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
        data_out <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (data_in == 1'b1) begin
                    state <= PULSE_RISING;
                end else begin
                    state <= IDLE;
                end
                data_out <= 1'b0;
            end
            PULSE_RISING: begin
                if (data_in == 1'b1) begin
                    state <= PULSE_FALLING;
                end else begin
                    state <= IDLE;
                end
                data_out <= 1'b0;
            end
            PULSE_FALLING: begin
                if (data_in == 1'b0) begin
                    state <= IDLE;
                    data_out <= 1'b1;
                end else begin
                    state <= PULSE_FALLING;
                    data_out <= 1'b0;
                end
            end
            default: begin
                state <= IDLE;
                data_out <= 1'b0;
            end
        endcase
    end
end

endmodule
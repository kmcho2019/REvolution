module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 2-bit register to represent 4 states: IDLE, RISING, HIGH, FALLING
localparam IDLE = 2'b00;
localparam RISING = 2'b01;
localparam HIGH = 2'b10;
localparam FALLING = 2'b11;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
        data_out <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data_in) begin
                    state <= RISING;
                    data_out <= 0;
                end else begin
                    state <= IDLE;
                    data_out <= 0;
                end
            end
            RISING: begin
                if (data_in) begin
                    state <= HIGH;
                    data_out <= 0;
                end else begin
                    state <= IDLE;
                    data_out <= 0;
                end
            end
            HIGH: begin
                if (data_in) begin
                    state <= HIGH;
                    data_out <= 0;
                end else begin
                    state <= FALLING;
                    data_out <= 0;
                end
            end
            FALLING: begin
                if (~data_in) begin
                    state <= IDLE;
                    data_out <= 1; // set data_out to 1 at the end cycle of the pulse
                end else begin
                    state <= IDLE;
                    data_out <= 0;
                end
            end
        endcase
    end
end

endmodule
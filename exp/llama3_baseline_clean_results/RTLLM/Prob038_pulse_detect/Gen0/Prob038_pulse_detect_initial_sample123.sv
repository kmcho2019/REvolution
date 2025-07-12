module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 2-bit register to represent the current state

localparam IDLE = 2'b00; // initial state
localparam RISING = 2'b01; // rising edge detected
localparam FALLING = 2'b10; // falling edge detected

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // reset condition
        state <= IDLE;
        data_out <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (data_in) begin
                    state <= RISING;
                end else begin
                    state <= IDLE;
                end
                data_out <= 1'b0;
            end
            RISING: begin
                if (data_in) begin
                    state <= RISING;
                end else begin
                    state <= FALLING;
                end
                data_out <= 1'b0;
            end
            FALLING: begin
                if (~data_in) begin
                    state <= IDLE;
                    data_out <= 1'b1;
                end else begin
                    state <= FALLING;
                end
            end
        endcase
    end
end

endmodule
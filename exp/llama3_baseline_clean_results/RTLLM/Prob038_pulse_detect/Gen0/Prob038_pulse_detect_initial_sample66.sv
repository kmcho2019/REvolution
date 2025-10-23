module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // idle, rising, falling

localparam IDLE = 2'b00;
localparam RISING = 2'b01;
localparam FALLING = 2'b10;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
        data_out <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data_in == 1) begin
                    state <= RISING;
                    data_out <= 0;
                end else begin
                    state <= IDLE;
                    data_out <= 0;
                end
            end
            RISING: begin
                if (data_in == 1) begin
                    state <= RISING;
                    data_out <= 0;
                end else begin
                    state <= FALLING;
                    data_out <= 0;
                end
            end
            FALLING: begin
                if (data_in == 0) begin
                    state <= IDLE;
                    data_out <= 1;
                end else begin
                    state <= FALLING;
                    data_out <= 0;
                end
            end
        endcase
    end
end

endmodule
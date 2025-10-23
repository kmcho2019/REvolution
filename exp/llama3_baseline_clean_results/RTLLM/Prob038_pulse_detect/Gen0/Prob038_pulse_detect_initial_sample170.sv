module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Define states
parameter IDLE = 2'b00;
parameter RISING = 2'b01;
parameter FALLING = 2'b10;

reg [1:0] state;
reg [1:0] next_state;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
        data_out <= 0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (data_in == 1) begin
                    next_state <= RISING;
                    data_out <= 0;
                end else begin
                    next_state <= IDLE;
                    data_out <= 0;
                end
            end
            RISING: begin
                if (data_in == 1) begin
                    next_state <= RISING;
                    data_out <= 0;
                end else if (data_in == 0) begin
                    next_state <= FALLING;
                    data_out <= 0;
                end
            end
            FALLING: begin
                next_state <= IDLE;
                data_out <= 1;
            end
            default: begin
                next_state <= IDLE;
                data_out <= 0;
            end
        endcase
    end
end

endmodule
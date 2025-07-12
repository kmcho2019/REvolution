module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Define the states
localparam IDLE = 2'b00;
localparam RISING = 2'b01;
localparam HIGH = 2'b10;
localparam FALLING = 2'b11;

reg [1:0] state;
reg [1:0] next_state;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
        data_out <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data_in) begin
                    state <= RISING;
                end else begin
                    state <= IDLE;
                end
                data_out <= 0;
            end
            RISING: begin
                if (data_in) begin
                    state <= HIGH;
                end else begin
                    state <= IDLE;
                end
                data_out <= 0;
            end
            HIGH: begin
                if (~data_in) begin
                    state <= FALLING;
                end else begin
                    state <= HIGH;
                end
                data_out <= 0;
            end
            FALLING: begin
                state <= IDLE;
                data_out <= 1;
            end
            default: begin
                state <= IDLE;
                data_out <= 0;
            end
        endcase
    end
end

endmodule
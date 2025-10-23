module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Declare the states
localparam IDLE = 2'b00;
localparam RISING = 2'b01;
localparam FALLING = 2'b10;

// Declare the state register
reg [1:0] state;

// Initialize the state and data_out in the reset condition
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
                    state <= RISING;
                    data_out <= 0;
                end else begin
                    state <= FALLING;
                    data_out <= 0;
                end
            end
            FALLING: begin
                if (~data_in) begin
                    state <= IDLE;
                    data_out <= 1;
                end else begin
                    state <= IDLE;
                    data_out <= 0;
                end
            end
            default: begin
                state <= IDLE;
                data_out <= 0;
            end
        endcase
    end
end

endmodule
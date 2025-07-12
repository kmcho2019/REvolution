module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Define the states
parameter IDLE = 2'b00;
parameter PULSE_RISING = 2'b01;
parameter PULSE_FALLING = 2'b10;

// Declare the state register
reg [1:0] state;

// Sequential logic for current state and output signal
always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        state <= IDLE;
        data_out <= 0;
    end else begin
        case(state)
            IDLE: begin
                if(data_in) begin
                    state <= PULSE_RISING;
                end else begin
                    state <= IDLE;
                end
                data_out <= 0;
            end
            PULSE_RISING: begin
                if(data_in) begin
                    state <= PULSE_FALLING;
                end else begin
                    state <= IDLE;
                end
                data_out <= 0;
            end
            PULSE_FALLING: begin
                if(!data_in) begin
                    state <= IDLE;
                    data_out <= 1;
                end else begin
                    state <= PULSE_FALLING;
                end
            end
        endcase
    end
end

endmodule
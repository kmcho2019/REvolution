module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Define the states
parameter IDLE = 1'b0;
parameter PULSE_DETECT = 1'b1;

// Declare the state register
reg state;
reg prev_data_in;

// Sequential logic for current state and output signal
always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        state <= IDLE;
        prev_data_in <= 0;
        data_out <= 0;
    end else begin
        prev_data_in <= data_in;
        if(state == IDLE) begin
            if(data_in && !prev_data_in) begin
                state <= PULSE_DETECT;
            end else begin
                state <= IDLE;
            end
            data_out <= 0;
        end else if(state == PULSE_DETECT) begin
            if(!data_in && prev_data_in) begin
                state <= IDLE;
                data_out <= 1;
            end else begin
                state <= PULSE_DETECT;
                data_out <= 0;
            end
        end
    end
end

endmodule
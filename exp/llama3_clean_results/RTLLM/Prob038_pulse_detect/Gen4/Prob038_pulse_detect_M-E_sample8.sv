module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // Current state of the FSM
reg prev_data_in; // Previous value of data_in

localparam IDLE = 2'b00; // IDLE state
localparam PULSE_HIGH = 2'b01; // PULSE_HIGH state
localparam PULSE_LOW = 2'b10; // PULSE_LOW state

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        data_out <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data_in && !prev_data_in) begin
                    // Input signal transitions from low to high
                    state <= PULSE_HIGH;
                    data_out <= 0;
                end else begin
                    state <= IDLE;
                    data_out <= 0;
                end
            end
            PULSE_HIGH: begin
                if (!data_in && prev_data_in) begin
                    // Input signal transitions from high to low
                    state <= PULSE_LOW;
                    data_out <= 1;
                end else begin
                    state <= PULSE_HIGH;
                    data_out <= 0;
                end
            end
            PULSE_LOW: begin
                if (data_in && !prev_data_in) begin
                    // Input signal transitions from low to high
                    state <= IDLE;
                    data_out <= 0;
                end else begin
                    state <= PULSE_LOW;
                    data_out <= 0;
                end
            end
        endcase
        prev_data_in <= data_in; // Update previous value of data_in
    end
end

endmodule
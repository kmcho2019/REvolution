module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output data_out
);

reg [1:0] state; // 2-bit state register
parameter IDLE = 2'b00, PULSE_HIGH = 2'b01, PULSE_LOW = 2'b10;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        state <= IDLE; // Initialize state to IDLE
    end else begin
        case (state)
            IDLE: 
                if (data_in) begin
                    state <= PULSE_HIGH;
                end
            PULSE_HIGH: 
                if (~data_in) begin
                    state <= PULSE_LOW;
                end
            PULSE_LOW: 
                state <= IDLE;
            default: 
                state <= IDLE;
        endcase
    end
end

assign data_out = (state == PULSE_LOW);

endmodule
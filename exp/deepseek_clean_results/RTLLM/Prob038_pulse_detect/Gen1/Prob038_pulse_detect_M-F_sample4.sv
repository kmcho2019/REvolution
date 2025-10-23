module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// State encoding
localparam IDLE           = 2'b00;
localparam GOT_0          = 2'b01;
localparam GOT_1          = 2'b10;
localparam PULSE_DETECTED = 2'b11;

reg [1:0] state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        data_out <= 1'b0;
    end
    else begin
        case (state)
            IDLE: begin
                data_out <= 1'b0;
                if (data_in == 1'b0)
                    state <= GOT_0;
            end
            GOT_0: begin
                data_out <= 1'b0;
                if (data_in == 1'b1)
                    state <= GOT_1;
                else
                    state <= GOT_0;  // Stay if consecutive 0s
            end
            GOT_1: begin
                data_out <= 1'b0;
                if (data_in == 1'b0) begin
                    state <= PULSE_DETECTED;
                    data_out <= 1'b1;  // Pulse detected on this cycle
                end
                else
                    state <= IDLE;  // Reset if consecutive 1s
            end
            PULSE_DETECTED: begin
                data_out <= 1'b0;
                state <= IDLE;  // Always return to IDLE
            end
            default: begin
                data_out <= 1'b0;
                state <= IDLE;
            end
        endcase
    end
end

endmodule
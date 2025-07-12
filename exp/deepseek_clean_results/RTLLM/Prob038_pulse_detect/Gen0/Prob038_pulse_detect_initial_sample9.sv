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
reg [1:0] next_state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        data_out <= 1'b0;
    end
    else begin
        state <= next_state;
        
        // Output is high only when we detect a complete pulse
        data_out <= (next_state == PULSE_DETECTED);
    end
end

always @(*) begin
    case (state)
        IDLE: begin
            if (data_in == 1'b0)
                next_state = GOT_0;
            else
                next_state = IDLE;
        end
        GOT_0: begin
            if (data_in == 1'b1)
                next_state = GOT_1;
            else
                next_state = GOT_0;  // Stay in GOT_0 if we get consecutive 0s
        end
        GOT_1: begin
            if (data_in == 1'b0)
                next_state = PULSE_DETECTED;
            else
                next_state = IDLE;  // If we get consecutive 1s, reset
        end
        PULSE_DETECTED: begin
            next_state = IDLE;  // Always return to IDLE after detection
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

endmodule
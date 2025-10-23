module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

// State encoding
localparam IDLE = 2'd0;
localparam HIGH = 2'd1;
localparam LOW  = 2'd2;

reg [1:0] state, next_state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        data_out <= 1'b0;
    end else begin
        state <= next_state;
        // data_out asserted only when pulse detected (from HIGH to LOW)
        data_out <= (state == HIGH && data_in == 1'b0 && next_state == LOW) ? 1'b1 : 1'b0;
    end
end

always @(*) begin
    case (state)
        IDLE: begin
            if (data_in == 1'b1)
                next_state = HIGH;
            else
                next_state = IDLE;
        end
        HIGH: begin
            if (data_in == 1'b0)
                next_state = LOW;
            else
                next_state = HIGH;
        end
        LOW: begin
            // After detecting pulse (0->1->0), wait for next rising edge
            if (data_in == 1'b1)
                next_state = HIGH;
            else
                next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

endmodule
module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    localparam WAIT = 1'b0;       // Waiting for rising edge
    localparam HIGH_DETECTED = 1'b1; // 1 detected, waiting for falling edge

    reg state, next_state;
    reg data_in_d;  // delayed data_in for edge detection

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= WAIT;
            data_in_d <= 1'b0;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            data_in_d <= data_in;
            // Output pulse on falling edge after HIGH_DETECTED state
            data_out <= (state == HIGH_DETECTED) && (data_in_d == 1'b1) && (data_in == 1'b0);
        end
    end

    always @(*) begin
        case(state)
            WAIT: 
                if (data_in)
                    next_state = HIGH_DETECTED;
                else
                    next_state = WAIT;
            HIGH_DETECTED: 
                if (data_in == 1'b0)
                    next_state = WAIT;
                else
                    next_state = HIGH_DETECTED;
            default: next_state = WAIT;
        endcase
    end

endmodule
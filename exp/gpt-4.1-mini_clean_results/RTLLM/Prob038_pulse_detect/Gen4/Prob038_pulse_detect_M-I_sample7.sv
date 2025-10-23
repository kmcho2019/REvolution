module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // One-hot state encoding (4 states)
    localparam IDLE          = 4'b0001;
    localparam WAIT_FOR_HIGH = 4'b0010;
    localparam WAIT_FOR_LOW  = 4'b0100;
    localparam PULSE_DETECTED= 4'b1000;

    reg [3:0] state, next_state;

    // Sequential logic: state register and registered output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state    <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;

            // Output asserted only in PULSE_DETECTED state, synchronized to clk
            if (next_state == PULSE_DETECTED)
                data_out <= 1'b1;
            else
                data_out <= 1'b0;
        end
    end

    // Combinational next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (data_in == 1'b0)
                    next_state = WAIT_FOR_HIGH;
                else
                    next_state = IDLE;
            end

            WAIT_FOR_HIGH: begin
                if (data_in == 1'b1)
                    next_state = WAIT_FOR_LOW;
                else // stay waiting for high with 0 input
                    next_state = WAIT_FOR_HIGH;
            end

            WAIT_FOR_LOW: begin
                if (data_in == 1'b0)
                    next_state = PULSE_DETECTED;
                else
                    next_state = WAIT_FOR_LOW; // keep waiting for final low
            end

            PULSE_DETECTED: begin
                next_state = IDLE; // After output pulse, go back to IDLE
            end

            default: next_state = IDLE;
        endcase
    end

endmodule
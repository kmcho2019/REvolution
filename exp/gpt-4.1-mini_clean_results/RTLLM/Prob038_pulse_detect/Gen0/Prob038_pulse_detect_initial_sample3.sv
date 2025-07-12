module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    typedef enum reg [1:0] {
        IDLE      = 2'b00, // Waiting for rising edge (0 -> 1)
        HIGH      = 2'b01, // data_in is 1, waiting for falling edge (1 -> 0)
        WAIT_ZERO = 2'b10  // Confirming falling edge, output pulse on detection
    } state_t;

    reg [1:0] state;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            data_out <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    data_out <= 1'b0;
                    if (data_in == 1'b1) 
                        state <= HIGH;
                    else
                        state <= IDLE;
                end

                HIGH: begin
                    data_out <= 1'b0;
                    if (data_in == 1'b0)
                        state <= WAIT_ZERO;
                    else
                        state <= HIGH;
                end

                WAIT_ZERO: begin
                    // At this state, data_in must be 0 to confirm pulse completion
                    data_out <= 1'b1;
                    if (data_in == 1'b0)
                        state <= IDLE;
                    else
                        // If data_in goes back to 1 without completing pulse, restart detection from HIGH
                        state <= HIGH;
                end

                default: begin
                    state <= IDLE;
                    data_out <= 1'b0;
                end
            endcase
        end
    end

endmodule
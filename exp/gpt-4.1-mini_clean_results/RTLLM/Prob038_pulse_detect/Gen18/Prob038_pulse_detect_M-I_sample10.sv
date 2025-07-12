module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding (1 bit)
    localparam IDLE         = 1'b0;
    localparam HIGH_DETECTED = 1'b1;

    reg state;
    reg data_in_d;  // delayed data_in for edge detection

    // Synchronous reset and logic combined
    always @(posedge clk) begin
        if (!rst_n) begin
            state     <= IDLE;
            data_in_d <= 1'b0;
            data_out  <= 1'b0;
        end else begin
            data_in_d <= data_in;
            data_out  <= 1'b0; // default output low

            case(state)
                IDLE: begin
                    if ((~data_in_d) & data_in) // rising edge detected
                        state <= HIGH_DETECTED;
                end

                HIGH_DETECTED: begin
                    if (data_in_d & (~data_in)) begin // falling edge detected
                        data_out <= 1'b1; // pulse end
                        state    <= IDLE;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule
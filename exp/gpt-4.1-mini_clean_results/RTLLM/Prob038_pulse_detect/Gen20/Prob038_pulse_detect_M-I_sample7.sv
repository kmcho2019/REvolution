module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    localparam IDLE = 1'b0;
    localparam HIGH = 1'b1;

    reg state;
    reg data_in_d;  // Delayed data_in for edge detection

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state     <= IDLE;
            data_in_d <= 1'b0;
            data_out  <= 1'b0;
        end else begin
            data_in_d <= data_in;

            // State update
            case (state)
                IDLE:
                    state <= data_in ? HIGH : IDLE;
                HIGH:
                    state <= data_in ? HIGH : IDLE;
                default:
                    state <= IDLE;
            endcase

            // Synchronous output: data_out asserted for 1 cycle on falling edge from HIGH state
            data_out <= (state == HIGH) && (data_in == 1'b0) && (data_in_d == 1'b1);
        end
    end

endmodule
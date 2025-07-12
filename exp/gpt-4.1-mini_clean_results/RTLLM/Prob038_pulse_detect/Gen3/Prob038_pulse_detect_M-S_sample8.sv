module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    localparam IDLE        = 1'b0;
    localparam PULSE_START = 1'b1;

    reg state;
    reg data_in_d; // delayed version of data_in to detect rising edge

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state    <= IDLE;
            data_out <= 1'b0;
            data_in_d <= 1'b0;
        end else begin
            data_in_d <= data_in; // sample input for edge detection
            data_out <= 1'b0;     // default output

            case (state)
                IDLE: begin
                    // Detect rising edge: 0->1
                    if (~data_in_d & data_in) 
                        state <= PULSE_START;
                end

                PULSE_START: begin
                    // Wait for falling edge 1->0 (pulse end)
                    if (data_in == 1'b0) begin
                        data_out <= 1'b1; // pulse detected at end cycle
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

endmodule
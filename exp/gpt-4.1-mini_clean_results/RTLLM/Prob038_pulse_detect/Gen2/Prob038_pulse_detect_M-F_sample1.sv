module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    localparam WAIT_FOR_0 = 2'b00; // Waiting for initial 0 to start pulse detection
    localparam GOT_0      = 2'b01; // Detected first 0
    localparam GOT_1      = 2'b10; // Detected 1 after 0, waiting for last 0

    reg [1:0] state;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state    <= WAIT_FOR_0;
            data_out <= 1'b0;
        end else begin
            case (state)
                WAIT_FOR_0: begin
                    data_out <= 1'b0;
                    if (data_in == 1'b0)
                        state <= GOT_0;
                    else
                        state <= WAIT_FOR_0;
                end

                GOT_0: begin
                    data_out <= 1'b0;
                    if (data_in == 1'b1)
                        state <= GOT_1;
                    else
                        state <= GOT_0; // stay if data_in remains 0
                end

                GOT_1: begin
                    if (data_in == 1'b0) begin
                        // Pulse detected: 0->1->0 sequence completed
                        data_out <= 1'b1;
                        state    <= GOT_0; // ready for next pulse starting with 0
                    end else begin
                        data_out <= 1'b0;
                        state    <= GOT_1; // stay waiting for last 0
                    end
                end

                default: begin
                    state    <= WAIT_FOR_0;
                    data_out <= 1'b0;
                end
            endcase
        end
    end

endmodule
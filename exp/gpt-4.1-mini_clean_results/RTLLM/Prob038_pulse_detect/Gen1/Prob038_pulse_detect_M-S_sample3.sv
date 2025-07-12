module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    reg [1:0] state;
    localparam IDLE         = 2'd0,
               HIGH_DETECTED= 2'd1,
               WAIT_FOR_LOW = 2'd2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state    <= IDLE;
            data_out <= 1'b0;
        end else begin
            data_out <= 1'b0; // default no pulse

            case (state)
                IDLE: begin
                    if (data_in == 1'b1)
                        state <= HIGH_DETECTED;
                    else
                        state <= IDLE;
                end

                HIGH_DETECTED: begin
                    if (data_in == 1'b1)
                        state <= WAIT_FOR_LOW;
                    else
                        state <= IDLE;
                end

                WAIT_FOR_LOW: begin
                    if (data_in == 1'b0) begin
                        state    <= IDLE;
                        data_out <= 1'b1; // pulse detected
                    end else
                        state <= WAIT_FOR_LOW;
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule
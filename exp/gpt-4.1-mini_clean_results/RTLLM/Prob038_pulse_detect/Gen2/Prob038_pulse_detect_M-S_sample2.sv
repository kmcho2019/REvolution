module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    localparam IDLE = 2'b00;
    localparam WAIT_1 = 2'b01;
    localparam WAIT_0 = 2'b10;

    reg [1:0] state;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state    <= IDLE;
            data_out <= 1'b0;
        end else begin
            data_out <= 1'b0;  // default no pulse output
            case (state)
                IDLE: begin
                    if (data_in == 1'b0)
                        state <= WAIT_1;
                    else
                        state <= IDLE;
                end
                WAIT_1: begin
                    if (data_in == 1'b1)
                        state <= WAIT_0;
                    else if (data_in == 1'b0)
                        state <= WAIT_1;
                    else
                        state <= IDLE;
                end
                WAIT_0: begin
                    if (data_in == 1'b0) begin
                        state    <= WAIT_1;
                        data_out <= 1'b1; // pulse detected (0->1->0)
                    end else if (data_in == 1'b1)
                        state <= WAIT_0;
                    else
                        state <= IDLE;
                end
                default: begin
                    state    <= IDLE;
                    data_out <= 1'b0;
                end
            endcase
        end
    end

endmodule
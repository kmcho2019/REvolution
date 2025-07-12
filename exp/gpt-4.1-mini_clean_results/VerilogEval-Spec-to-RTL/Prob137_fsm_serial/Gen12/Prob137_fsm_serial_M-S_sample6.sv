module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    localparam IDLE = 2'd0, RECEIVE = 2'd1, CHECK_STOP = 2'd2, WAIT_STOP = 2'd3;

    reg [1:0] state;
    reg [2:0] bit_cnt;
    reg [7:0] data;

    always @(posedge clk) begin
        if (reset) begin
            state   <= IDLE;
            bit_cnt <= 3'd0;
            data    <= 8'd0;
            done    <= 1'b0;
        end else begin
            done <= 1'b0;
            case (state)
                IDLE: begin
                    bit_cnt <= 3'd0;
                    data    <= 8'd0;
                    if (in == 1'b0)
                        state <= RECEIVE;
                end
                RECEIVE: begin
                    data <= {in, data[7:1]}; // shift right, LSB first
                    bit_cnt <= bit_cnt + 1'b1;
                    if (bit_cnt == 3'd7)
                        state <= CHECK_STOP;
                end
                CHECK_STOP: begin
                    if (in == 1'b1) begin
                        done <= 1'b1;
                        state <= IDLE;
                    end else begin
                        state <= WAIT_STOP;
                    end
                end
                WAIT_STOP: begin
                    if (in == 1'b1)
                        state <= IDLE;
                end
            endcase
        end
    end

endmodule
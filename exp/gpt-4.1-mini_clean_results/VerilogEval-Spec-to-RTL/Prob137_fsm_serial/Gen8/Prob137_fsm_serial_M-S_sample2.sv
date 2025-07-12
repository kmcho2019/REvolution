module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

    // State encoding
    localparam IDLE    = 2'd0;
    localparam RECEIVE = 2'd1;
    localparam STOP    = 2'd2;

    reg [1:0] state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            data_reg <= 8'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // default done low unless set below

            case(state)
                IDLE: begin
                    bit_count <= 3'd0;
                    data_reg <= 8'd0;
                    if (in == 1'b0)
                        state <= RECEIVE;
                end
                RECEIVE: begin
                    data_reg <= {in, data_reg[7:1]};
                    bit_count <= bit_count + 1'b1;
                    if (bit_count == 3'd7)
                        state <= STOP;
                end
                STOP: begin
                    if (in == 1'b1) begin
                        done <= 1'b1;
                        state <= IDLE;
                    end else begin
                        // Stop bit error: stay in STOP until line goes high again
                        state <= STOP;
                    end
                end
            endcase
        end
    end

endmodule
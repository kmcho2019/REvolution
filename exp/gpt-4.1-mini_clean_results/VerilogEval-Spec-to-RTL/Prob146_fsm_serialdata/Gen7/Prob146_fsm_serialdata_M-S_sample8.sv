module TopModule (
    input  clk,
    input  in,
    input  reset,
    output reg [7:0] out_byte,
    output reg done
);

    localparam IDLE    = 2'd0;
    localparam RECEIVE = 2'd1;
    localparam STOP    = 2'd2;

    reg [1:0] state;
    reg [2:0] bit_count;
    reg [7:0] data_shift;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            data_shift <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // default

            case (state)
                IDLE: begin
                    if (in == 1'b0) begin // start bit detected
                        state <= RECEIVE;
                        bit_count <= 3'd0;
                        data_shift <= 8'd0;
                    end
                end

                RECEIVE: begin
                    // Shift in LSB first
                    data_shift <= {in, data_shift[7:1]};
                    if (bit_count == 3'd7) begin
                        state <= STOP;
                    end else begin
                        bit_count <= bit_count + 1;
                    end
                end

                STOP: begin
                    if (in == 1'b1) begin // valid stop bit
                        out_byte <= data_shift;
                        done <= 1'b1;
                        state <= IDLE;
                    end
                    // else stay in STOP waiting for valid stop bit (line idle)
                end
            endcase
        end
    end

endmodule
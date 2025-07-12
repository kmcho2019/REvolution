module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // State encoding
    localparam IDLE      = 2'd0;
    localparam RECEIVE   = 2'd1;
    localparam STOP      = 2'd2;
    localparam WAIT_STOP = 2'd3;

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
            done <= 1'b0; // default no done
            
            case (state)
                IDLE: begin
                    if (in == 1'b0) begin // start bit detected
                        state <= RECEIVE;
                        bit_count <= 3'd0;
                        data_shift <= 8'd0;
                    end
                end

                RECEIVE: begin
                    data_shift <= {in, data_shift[7:1]}; // LSB first
                    if (bit_count == 3'd7) begin
                        state <= STOP;
                    end
                    bit_count <= bit_count + 1;
                end

                STOP: begin
                    if (in == 1'b1) begin // valid stop bit
                        out_byte <= data_shift;
                        done <= 1'b1;
                        state <= IDLE;
                    end else begin
                        state <= WAIT_STOP;
                    end
                end

                WAIT_STOP: begin
                    if (in == 1'b1) begin
                        state <= IDLE;
                    end
                end

            endcase
        end
    end

endmodule
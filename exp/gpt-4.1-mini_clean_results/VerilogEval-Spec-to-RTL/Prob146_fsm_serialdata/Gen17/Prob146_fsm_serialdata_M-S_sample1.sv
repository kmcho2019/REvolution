module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
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
            state     <= IDLE;
            bit_count <= 3'd0;
            data_shift <= 8'd0;
            out_byte  <= 8'd0;
            done      <= 1'b0;
        end else begin
            done <= 1'b0; // Default no done

            case (state)
                IDLE: begin
                    if (in == 1'b0) begin // Start bit detected
                        state     <= RECEIVE;
                        bit_count <= 3'd0;
                        data_shift <= 8'd0;
                    end
                end

                RECEIVE: begin
                    // Shift in new bit LSB first: shift right, new bit at MSB
                    data_shift <= {in, data_shift[7:1]};
                    bit_count <= bit_count + 3'd1;
                    if (bit_count == 3'd7)
                        state <= STOP;
                end

                STOP: begin
                    if (in == 1'b1) begin // Valid stop bit
                        out_byte <= data_shift;
                        done <= 1'b1;
                        state <= IDLE;
                    end else begin
                        // Invalid stop bit, wait until line goes idle
                        state <= WAIT_STOP;
                    end
                end

                WAIT_STOP: begin
                    if (in == 1'b1) begin // Wait for line idle
                        state <= IDLE;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule
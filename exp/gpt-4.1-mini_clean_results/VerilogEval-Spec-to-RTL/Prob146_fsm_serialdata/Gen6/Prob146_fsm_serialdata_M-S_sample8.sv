module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // State encoding
    localparam IDLE    = 2'd0;
    localparam RECEIVE = 2'd1;
    localparam DONE    = 2'd2;

    reg [1:0] state;
    reg [3:0] bit_index;  // counts from 0 to 9: 0-7 data bits, 8 stop bit, 9 means done cycle
    reg [7:0] data_shift;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_index <= 4'd0;
            data_shift <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // default

            case(state)
                IDLE: begin
                    if (in == 1'b0) begin // start bit detected
                        state <= RECEIVE;
                        bit_index <= 4'd0;
                        data_shift <= 8'd0;
                    end
                end

                RECEIVE: begin
                    if (bit_index < 4'd8) begin
                        // shift in data bits LSB first
                        data_shift <= {in, data_shift[7:1]};
                        bit_index <= bit_index + 1'b1;
                    end else if (bit_index == 4'd8) begin
                        // stop bit check
                        if (in == 1'b1) begin
                            // valid stop bit, go to DONE state
                            out_byte <= data_shift;
                            done <= 1'b1;
                            state <= DONE;
                            bit_index <= 4'd9; // mark done cycle
                        end else begin
                            // invalid stop bit, keep waiting until line goes idle (logic 1)
                            // Do not advance bit_index, just wait here until in==1
                            // stay in RECEIVE with bit_index = 8
                        end
                    end else begin
                        // Should not happen, but stay safe: go to IDLE
                        state <= IDLE;
                    end
                end

                DONE: begin
                    // Done pulse lasts one cycle, then return to IDLE when line is idle (in == 1)
                    if (in == 1'b1) begin
                        state <= IDLE;
                        bit_index <= 4'd0;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule
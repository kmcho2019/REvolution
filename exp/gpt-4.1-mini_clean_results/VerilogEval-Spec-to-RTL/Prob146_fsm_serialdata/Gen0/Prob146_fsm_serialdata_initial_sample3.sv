module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    localparam IDLE    = 2'd0;
    localparam RECEIVE = 2'd1;
    localparam STOP    = 2'd2;

    reg [1:0] state, next_state;
    reg [3:0] bit_count;       // counts from 0 to 7 for data bits
    reg [7:0] data_shift;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 4'd0;
            data_shift <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // default: done deasserted each clock

            case (state)
                IDLE: begin
                    if (in == 1'b0) begin // start bit detected
                        state <= RECEIVE;
                        bit_count <= 4'd0;
                        data_shift <= 8'd0;
                    end
                end

                RECEIVE: begin
                    // Shift in LSB first
                    data_shift <= {in, data_shift[7:1]};
                    bit_count <= bit_count + 1;

                    if (bit_count == 4'd7) begin
                        state <= STOP;
                    end
                end

                STOP: begin
                    if (in == 1'b1) begin // correct stop bit
                        out_byte <= data_shift;
                        done <= 1'b1;
                        state <= IDLE;
                    end else begin
                        // Bad stop bit, wait here until stop bit is correct
                        // No done assertion
                        state <= STOP; // stay in stop until in==1
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule
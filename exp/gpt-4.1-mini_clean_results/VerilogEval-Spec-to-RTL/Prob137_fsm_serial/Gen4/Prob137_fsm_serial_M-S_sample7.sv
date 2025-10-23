module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);
    // State encoding
    localparam IDLE      = 2'b00;
    localparam RECEIVE   = 2'b01;
    localparam WAIT_STOP = 2'b10;

    reg [1:0] state;
    reg [3:0] bit_count; // counts from 0 to 8 (8 data bits + stop bit)

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 4'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // default

            case(state)
                IDLE: begin
                    bit_count <= 4'd0;
                    if (in == 1'b0) // start bit detected
                        state <= RECEIVE;
                end

                RECEIVE: begin
                    bit_count <= bit_count + 1'b1;
                    if (bit_count == 4'd8) begin
                        // stop bit received; in is current bit
                        if (in == 1'b1) begin
                            done <= 1'b1;
                            state <= IDLE;
                        end else begin
                            state <= WAIT_STOP;
                        end
                        bit_count <= 4'd0;
                    end
                end

                WAIT_STOP: begin
                    if (in == 1'b1) begin
                        state <= IDLE;
                    end
                end

                default: begin
                    state <= IDLE;
                    bit_count <= 4'd0;
                end
            endcase
        end
    end
endmodule
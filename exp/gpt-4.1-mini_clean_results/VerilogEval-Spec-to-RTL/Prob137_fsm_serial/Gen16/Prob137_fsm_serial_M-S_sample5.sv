module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // State encoding
    localparam IDLE      = 2'b00;
    localparam RECEIVE   = 2'b01;
    localparam WAIT_STOP = 2'b10;

    reg [1:0] state;
    reg [2:0] bit_count;

    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            done      <= 1'b0;
        end else begin
            done <= 1'b0; // default no done pulse
            case (state)
                IDLE: begin
                    bit_count <= 3'd0;
                    if (in == 1'b0)  // start bit detected
                        state <= RECEIVE;
                end

                RECEIVE: begin
                    bit_count <= bit_count + 1;
                    if (bit_count == 3'd7) begin
                        // After 8 data bits, check stop bit next cycle
                        if (in == 1'b1) begin
                            done  <= 1'b1;
                            state <= IDLE;
                            bit_count <= 3'd0;
                        end else begin
                            state <= WAIT_STOP;
                        end
                    end
                end

                WAIT_STOP: begin
                    if (in == 1'b1) begin
                        state <= IDLE;
                        bit_count <= 3'd0;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule
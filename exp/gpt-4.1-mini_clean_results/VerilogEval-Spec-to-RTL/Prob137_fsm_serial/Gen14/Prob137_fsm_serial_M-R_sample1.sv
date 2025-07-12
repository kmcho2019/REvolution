module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // State encoding
    localparam IDLE       = 2'd0;
    localparam RECEIVE    = 2'd1;
    localparam CHECK_STOP = 2'd2;
    localparam WAIT_STOP  = 2'd3;

    reg [1:0] state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            done      <= 1'b0;
        end else begin
            done <= 1'b0;  // Default done is 0 unless set later
            case (state)
                IDLE: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                    if (in == 1'b0)  // Start bit detected
                        state <= RECEIVE;
                    else
                        state <= IDLE;
                end

                RECEIVE: begin
                    // Shift new bit into MSB to preserve LSB-first order
                    shift_reg <= {in, shift_reg[7:1]};
                    if (bit_count == 3'd7) begin
                        bit_count <= 3'd0;
                        state <= CHECK_STOP;
                    end else begin
                        bit_count <= bit_count + 1;
                        state <= RECEIVE;
                    end
                end

                CHECK_STOP: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                    if (in == 1'b1) begin
                        done <= 1'b1;
                        state <= IDLE;
                    end else begin
                        state <= WAIT_STOP;  // Framing error: wait for stop bit
                    end
                end

                WAIT_STOP: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                    if (in == 1'b1)
                        state <= IDLE;
                    else
                        state <= WAIT_STOP;
                end

                default: begin
                    state <= IDLE;
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                    done <= 1'b0;
                end
            endcase
        end
    end

endmodule
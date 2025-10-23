module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // State encoding
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP    = 2'b10;

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
            done <= 1'b0;  // default done low
            case (state)
                IDLE: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                    if (in == 1'b0)    // start bit detected
                        state <= RECEIVE;
                    else
                        state <= IDLE;
                end

                RECEIVE: begin
                    shift_reg <= {shift_reg[6:0], in};  // LSB first shift left
                    if (bit_count == 3'd7) begin
                        bit_count <= 3'd0;
                        state <= STOP;
                    end else begin
                        bit_count <= bit_count + 1'b1;
                        state <= RECEIVE;
                    end
                end

                STOP: begin
                    if (in == 1'b1) begin  // valid stop bit
                        done <= 1'b1;      // done pulse one cycle
                        state <= IDLE;
                    end else begin
                        // wait for stop bit if invalid
                        state <= STOP;
                    end
                end

                default: begin
                    state     <= IDLE;
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                    done      <= 1'b0;
                end
            endcase
        end
    end

endmodule
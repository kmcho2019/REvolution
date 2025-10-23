module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // One-hot encoded states
    localparam IDLE      = 4'b0001;
    localparam RECEIVE   = 4'b0010;
    localparam STOP      = 4'b0100;
    localparam WAIT_STOP = 4'b1000;

    reg [3:0] state;
    reg [3:0] next_state;   // one-hot too, but only used temporarily
    reg [2:0] bit_count;
    reg [7:0] data_shift;
    reg       shift_en;

    // State register and data logic
    always @(posedge clk) begin
        if (reset) begin
            state      <= IDLE;
            bit_count  <= 3'd0;
            data_shift <= 8'd0;
            out_byte   <= 8'd0;
            done       <= 1'b0;
            shift_en   <= 1'b0;
        end else begin
            done <= 1'b0;  // default done low

            case(state)
                IDLE: begin
                    if (in == 1'b0) begin // Detect start bit
                        state      <= RECEIVE;
                        bit_count  <= 3'd0;
                        data_shift <= 8'd0;
                        shift_en   <= 1'b1;
                    end else begin
                        shift_en <= 1'b0;
                    end
                end

                RECEIVE: begin
                    if (shift_en) begin
                        // Shift in LSB first by shifting right and inserting in MSB
                        data_shift <= {in, data_shift[7:1]};
                        bit_count  <= bit_count + 1'b1;
                    end
                    if (bit_count == 3'd7) begin
                        state    <= STOP;
                        shift_en <= 1'b0;
                    end
                end

                STOP: begin
                    if (in == 1'b1) begin // Valid stop bit
                        out_byte <= data_shift;
                        done     <= 1'b1;
                        state    <= IDLE;
                    end else begin
                        state <= WAIT_STOP; // Wait for stop bit
                    end
                end

                WAIT_STOP: begin
                    if (in == 1'b1) begin
                        state <= IDLE;
                    end
                end

                default: begin
                    state      <= IDLE;
                    bit_count  <= 3'd0;
                    data_shift <= 8'd0;
                    shift_en   <= 1'b0;
                    done       <= 1'b0;
                end
            endcase
        end
    end

endmodule
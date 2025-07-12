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

    reg [1:0] state, next_state;
    reg [7:0] data_shift;
    reg [2:0] bit_count;

    always @(posedge clk) begin
        if (reset) begin
            state      <= IDLE;
            bit_count  <= 3'd0;
            data_shift <= 8'd0;
            out_byte   <= 8'd0;
            done       <= 1'b0;
        end else begin
            done <= 1'b0; // default no done pulse

            state <= next_state;

            case (state)
                IDLE: begin
                    if (in == 1'b0) begin // start bit detected
                        bit_count  <= 3'd0;
                        data_shift <= 8'd0;
                    end
                end

                RECEIVE: begin
                    data_shift <= {in, data_shift[7:1]};
                    bit_count <= bit_count + 3'd1;
                end

                STOP: begin
                    if (in == 1'b1) begin
                        out_byte <= data_shift;
                        done <= 1'b1;
                    end
                end

                WAIT_STOP: begin
                    // wait for line to return idle (1)
                end
            endcase
        end
    end

    // Next state logic combinational
    always @(*) begin
        case (state)
            IDLE: 
                if (in == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;

            RECEIVE:
                if (bit_count == 3'd7)
                    next_state = STOP;
                else
                    next_state = RECEIVE;

            STOP:
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;

            WAIT_STOP:
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;

            default: next_state = IDLE;
        endcase
    end

endmodule
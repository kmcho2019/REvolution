module TopModule (
    input  clk,
    input  in,
    input  reset,
    output reg [7:0] out_byte,
    output reg done
);

    // State encoding using localparams for simplicity
    localparam IDLE      = 2'd0;
    localparam RECEIVE   = 2'd1;
    localparam STOP      = 2'd2;
    localparam WAIT_STOP = 2'd3;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_shift;

    // Next state logic combinational
    always @(*) begin
        case (state)
            IDLE:       next_state = (in == 1'b0) ? RECEIVE : IDLE;
            RECEIVE:    next_state = (bit_count == 3'd7) ? STOP : RECEIVE;
            STOP:       next_state = (in == 1'b1) ? IDLE : WAIT_STOP;
            WAIT_STOP:  next_state = (in == 1'b1) ? IDLE : WAIT_STOP;
            default:    next_state = IDLE;
        endcase
    end

    // Sequential logic: state update, bit count, data shift, output and done
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            data_shift <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0;

            case (state)
                IDLE: begin
                    bit_count <= 3'd0;
                    data_shift <= 8'd0;
                end

                RECEIVE: begin
                    // Shift right to capture LSB first
                    data_shift <= {in, data_shift[7:1]};
                    bit_count <= bit_count + 1;
                end

                STOP: begin
                    if (in == 1'b1) begin
                        out_byte <= data_shift;
                        done <= 1'b1;
                    end
                    // else wait in WAIT_STOP, no update here
                end

                WAIT_STOP: begin
                    // Wait for stop bit = 1; no changes to data_shift or bit_count
                end
            endcase
        end
    end

endmodule
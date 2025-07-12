module TopModule (
    input        clk,
    input        in,
    input        reset,
    output reg [7:0] out_byte,
    output       done
);

    // State encoding
    localparam IDLE      = 2'b00;
    localparam RECEIVE   = 2'b01;
    localparam STOP      = 2'b10;
    localparam WAIT_STOP = 2'b11;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_shift;

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: 
                next_state = (in == 1'b0) ? RECEIVE : IDLE;

            RECEIVE:
                next_state = (bit_count == 3'd7) ? STOP : RECEIVE;

            STOP:
                next_state = (in == 1'b1) ? IDLE : WAIT_STOP;

            WAIT_STOP:
                next_state = (in == 1'b1) ? IDLE : WAIT_STOP;

            default:
                next_state = IDLE;
        endcase
    end

    // Sequential state, bit counter, and shift register update
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            data_shift <= 8'd0;
            out_byte  <= 8'd0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    if (in == 1'b0) begin
                        bit_count <= 3'd0;
                        data_shift <= 8'd0;
                    end
                end

                RECEIVE: begin
                    data_shift <= {in, data_shift[7:1]}; // shift in LSB first
                    bit_count <= bit_count + 1;
                end

                STOP: begin
                    if (in == 1'b1)
                        out_byte <= data_shift;
                end

                WAIT_STOP: begin
                    // Hold bit_count and data_shift unchanged
                end
            endcase
        end
    end

    // Done signal combinational: asserted only for one cycle on valid stop bit
    assign done = (state == STOP) && (in == 1'b1);

endmodule
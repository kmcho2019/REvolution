module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    localparam IDLE       = 2'b00;
    localparam RECEIVE    = 2'b01;
    localparam CHECK_STOP = 2'b10;
    localparam WAIT_STOP  = 2'b11;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;

    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            data_reg  <= 8'd0;
            done      <= 1'b0;
        end else begin
            done <= 1'b0;  // Default done low

            state <= next_state;

            case (state)
                IDLE: begin
                    bit_count <= 3'd0;
                    data_reg  <= 8'd0;
                end

                RECEIVE: begin
                    data_reg  <= {in, data_reg[7:1]}; // Shift right, LSB first
                    bit_count <= bit_count + 1;
                end

                CHECK_STOP: begin
                    if (in == 1'b1)
                        done <= 1'b1;
                end

                WAIT_STOP: begin
                    // stay here until stop bit 1 detected
                end
            endcase
        end
    end

    always @(*) begin
        case (state)
            IDLE:       next_state = (in == 1'b0) ? RECEIVE : IDLE;
            RECEIVE:    next_state = (bit_count == 3'd7) ? CHECK_STOP : RECEIVE;
            CHECK_STOP: next_state = (in == 1'b1) ? IDLE : WAIT_STOP;
            WAIT_STOP:  next_state = (in == 1'b1) ? IDLE : WAIT_STOP;
            default:    next_state = IDLE;
        endcase
    end

endmodule
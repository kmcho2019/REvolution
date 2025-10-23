module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // State encoding using localparams for plain Verilog compatibility
    localparam IDLE       = 2'b00;
    localparam RECEIVE    = 2'b01;
    localparam CHECK_STOP = 2'b10;
    localparam WAIT_STOP  = 2'b11;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;    // counts number of received data bits 0..7
    reg [7:0] shift_reg;    // 8-bit shift register

    // Next state logic combinational block
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end
            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = CHECK_STOP;
                else
                    next_state = RECEIVE;
            end
            CHECK_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end
            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic combinational block (done asserted only in CHECK_STOP with stop bit == 1)
    always @(*) begin
        if (state == CHECK_STOP && in == 1'b1)
            done = 1'b1;
        else
            done = 1'b0;
    end

    // Sequential block: state, bit_count, shift_reg update with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
        end else begin
            state <= next_state;
            case (next_state)
                IDLE: begin
                    // Clear registers when going to IDLE (either after reset or after a byte)
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end
                RECEIVE: begin
                    // Shift left: LSB first protocol, new bit shifted into bit 0
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 1'b1;
                end
                CHECK_STOP: begin
                    // Keep bit_count and shift_reg unchanged; reset handled on IDLE
                end
                WAIT_STOP: begin
                    // Wait state, hold registers until stop bit is received (IDLE)
                end
                default: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end
            endcase
        end
    end

endmodule
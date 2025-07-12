module TopModule (
    input  clk,
    input  in,
    input  reset,
    output reg [7:0] out_byte,
    output reg done
);

    // State encoding using localparam
    localparam IDLE    = 2'd0;
    localparam RECEIVE = 2'd1;
    localparam STOP    = 2'd2;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_shift;

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            IDLE:
                if (in == 1'b0) // Detect start bit
                    next_state = RECEIVE;
                else
                    next_state = IDLE;

            RECEIVE:
                if (bit_count == 3'd7)
                    next_state = STOP;
                else
                    next_state = RECEIVE;

            STOP:
                if (in == 1'b1) // Correct stop bit detected
                    next_state = IDLE;
                else
                    next_state = STOP; // Wait until stop bit is correct

            default:
                next_state = IDLE;
        endcase
    end

    // State register update
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Shift register and bit_count update
    always @(posedge clk) begin
        if (reset) begin
            bit_count <= 3'd0;
            data_shift <= 8'd0;
        end else begin
            case (state)
                IDLE: begin
                    bit_count <= 3'd0;
                    data_shift <= 8'd0;
                end

                RECEIVE: begin
                    // Shift right, input bit into MSB (LSB-first reception)
                    data_shift <= {in, data_shift[7:1]};
                    bit_count <= bit_count + 1;
                end

                STOP: begin
                    bit_count <= bit_count;
                    data_shift <= data_shift;
                end

                default: begin
                    bit_count <= bit_count;
                    data_shift <= data_shift;
                end
            endcase
        end
    end

    // Output logic and done signal
    always @(posedge clk) begin
        if (reset) begin
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // default

            if (state == STOP && in == 1'b1) begin
                out_byte <= data_shift;
                done <= 1'b1;
            end
        end
    end

endmodule
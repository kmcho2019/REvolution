module TopModule (
    input        clk,
    input        in,
    input        reset,
    output reg [7:0] out_byte,
    output reg   done
);

    // State encoding
    localparam IDLE      = 2'd0;
    localparam RECEIVING = 2'd1;
    localparam STOP      = 2'd2;

    reg [1:0] state, next_state;
    reg [3:0] bit_count;       // to count 8 bits (0 to 7)
    reg [7:0] data_shift_reg;

    // Sequential state and registers update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            data_shift_reg <= 8'b0;
            out_byte <= 8'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            done <= 1'b0; // default done deassert

            case (state)
                IDLE: begin
                    bit_count <= 0;
                    data_shift_reg <= 8'b0;
                    // wait for start bit (0)
                end
                RECEIVING: begin
                    // shift in data bits, LSB first
                    data_shift_reg <= {in, data_shift_reg[7:1]};
                    bit_count <= bit_count + 1;
                end
                STOP: begin
                    if (in == 1'b1) begin
                        // Valid stop bit, output data and assert done
                        out_byte <= data_shift_reg;
                        done <= 1'b1;
                    end
                    // else wait here until stop bit is detected
                end
            endcase
        end
    end

    // Next state logic combinational
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (in == 1'b0) // start bit detected
                    next_state = RECEIVING;
                else
                    next_state = IDLE;
            end
            RECEIVING: begin
                if (bit_count == 4'd8)
                    next_state = STOP;
                else
                    next_state = RECEIVING;
            end
            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = STOP; // wait for stop bit to appear
            end
            default: next_state = IDLE;
        endcase
    end

endmodule
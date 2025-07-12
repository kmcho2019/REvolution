module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // One-hot state encoding
    localparam IDLE       = 4'b0001,
               RECEIVE    = 4'b0010,
               CHECK_STOP = 4'b0100,
               WAIT_STOP  = 4'b1000;

    reg [3:0] state, next_state;

    reg [7:0] shift_reg;
    reg [2:0] bit_count;

    // Next state logic (combinational)
    always @(*) begin
        case (state)
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

    // Sequential logic: state update and datapath
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 8'd0;
            bit_count <= 3'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // Default deassert done

            case (state)
                IDLE: begin
                    shift_reg <= 8'd0;
                    bit_count <= 3'd0;
                end
                RECEIVE: begin
                    // Shift right, load new bit into MSB (LSB first)
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 1;
                end
                CHECK_STOP: begin
                    bit_count <= 3'd0;
                    if (in == 1'b1)
                        done <= 1'b1;  // pulse done on correct stop bit
                end
                WAIT_STOP: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end
            endcase
        end
    end

endmodule
module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    localparam IDLE       = 2'd0;
    localparam RECEIVE    = 2'd1;
    localparam STOP_CHECK = 2'd2;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: 
                next_state = (in == 1'b0) ? RECEIVE : IDLE;

            RECEIVE:
                next_state = (bit_count == 3'd7) ? STOP_CHECK : RECEIVE;

            STOP_CHECK:
                next_state = (in == 1'b1) ? IDLE : STOP_CHECK;

            default:
                next_state = IDLE;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;
            done  <= 1'b0;

            case (state)
                IDLE: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end

                RECEIVE: begin
                    // Shift right by 1, insert new bit at MSB (shift_reg[7])
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 1'b1;
                end

                STOP_CHECK: begin
                    if (in == 1'b1)
                        done <= 1'b1;
                end

                default: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end
            endcase
        end
    end

endmodule
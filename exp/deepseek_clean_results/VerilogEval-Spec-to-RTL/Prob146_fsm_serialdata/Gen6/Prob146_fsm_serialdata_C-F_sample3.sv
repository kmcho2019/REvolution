module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // Optimized state encoding
    localparam IDLE   = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP   = 2'b10;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // Sequential logic with optimized updates
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            shift_reg <= 0;
            out_byte <= 0;
            done <= 0;
        end else begin
            state <= next_state;
            done <= 0;  // Default assignment

            case (state)
                IDLE: begin
                    if (in == 0) begin
                        bit_count <= 0;
                        shift_reg <= 0;
                    end
                end

                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]};  // Efficient LSB-first shift
                    bit_count <= bit_count + 1;
                end

                STOP: begin
                    if (in == 1) begin
                        out_byte <= shift_reg;
                        done <= 1;  // Single-cycle pulse
                    end
                end
            endcase
        end
    end

    // Optimized next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                next_state = (in == 0) ? RECEIVE : IDLE;
            end

            RECEIVE: begin
                next_state = (bit_count == 7) ? STOP : RECEIVE;
            end

            STOP: begin
                next_state = (in == 1) ? IDLE : STOP;  // Merged error handling
            end

            default: next_state = IDLE;
        endcase
    end

endmodule
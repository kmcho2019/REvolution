module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // FSM state encoding
    localparam IDLE   = 2'd0;
    localparam DATA   = 2'd1;
    localparam STOP   = 2'd2;
    localparam ERROR  = 2'd3;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // Combinational next_state logic
    always @(*) begin
        case(state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = DATA;
                else
                    next_state = IDLE;
            end

            DATA: begin
                if (bit_count == 3'd7)
                    next_state = STOP;
                else
                    next_state = DATA;
            end

            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR;
            end

            ERROR: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR;
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: state, bit_count, shift_reg, done
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;

            // Default done low; pulse high for one cycle on valid stop bit in STOP state
            done <= 1'b0;

            case(state)
                IDLE: begin
                    // Reset bit_count and shift_reg for new reception
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end

                DATA: begin
                    // Shift left, input bit enters LSB (bit 0)
                    shift_reg <= {shift_reg[6:0], in};
                    bit_count <= bit_count + 1'b1;
                end

                STOP: begin
                    // If stop bit correct, pulse done high for one cycle
                    if (in == 1'b1)
                        done <= 1'b1;

                    // Prepare bit_count and shift_reg for next reception
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end

                ERROR: begin
                    // Hold bit_count and shift_reg reset to zero to reduce toggling
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end
            endcase
        end
    end

endmodule
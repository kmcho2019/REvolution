module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // FSM states
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP    = 2'b10;
    localparam ERROR   = 2'b11;

    reg [1:0] state, next_state;
    reg [3:0] bit_count;  // Count to 8 (4 bits for potential expansion)
    reg [7:0] shift_reg;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            shift_reg <= 0;
            out_byte <= 0;
            done <= 0;
        end else begin
            state <= next_state;
            done <= 0;  // Default done to 0, set only in STOP state

            case (state)
                IDLE: begin
                    bit_count <= 0;
                    if (in == 0) begin
                        shift_reg <= 0;  // Prepare for new byte
                    end
                end

                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]};  // LSB first
                    bit_count <= bit_count + 1;
                end

                STOP: begin
                    if (in == 1) begin
                        out_byte <= shift_reg;
                        done <= 1;  // Pulse done when valid stop bit
                    end
                end

                ERROR: begin
                    // No operations needed, just waiting for stop bit
                end
            endcase
        end
    end

    // Combinational next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                next_state = (in == 0) ? RECEIVE : IDLE;
            end

            RECEIVE: begin
                if (bit_count == 8) begin  // Count to 8 for simpler comparison
                    next_state = STOP;
                end else begin
                    next_state = RECEIVE;
                end
            end

            STOP: begin
                if (in == 1) begin
                    next_state = IDLE;
                end else begin
                    next_state = ERROR;
                end
            end

            ERROR: begin
                next_state = (in == 1) ? IDLE : ERROR;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule
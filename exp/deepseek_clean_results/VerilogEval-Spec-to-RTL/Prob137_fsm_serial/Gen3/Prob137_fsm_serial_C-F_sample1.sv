module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // State encoding - binary for compact representation
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP    = 2'b10;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg done_reg;

    // State transition logic - optimized for timing
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            shift_reg <= 8'b0;
            done_reg <= 1'b0;
        end else begin
            state <= next_state;
            done_reg <= 1'b0;  // Default to 0, only set in STOP state

            case (state)
                IDLE: begin
                    bit_count <= 3'b0;
                end

                RECEIVE: begin
                    if (bit_count < 3'b111) begin
                        shift_reg <= {in, shift_reg[7:1]};  // Shift in LSB first
                        bit_count <= bit_count + 1;
                    end
                end

                STOP: begin
                    if (in == 1'b1) begin
                        done_reg <= 1'b1;  // Valid stop bit
                    end
                end
            endcase
        end
    end

    // Next state logic - optimized for minimal logic depth
    always @(*) begin
        case (state)
            IDLE: begin
                next_state = (in == 1'b0) ? RECEIVE : IDLE;
            end

            RECEIVE: begin
                next_state = (bit_count == 3'b111) ? STOP : RECEIVE;
            end

            STOP: begin
                next_state = (in == 1'b1) ? IDLE : STOP;  // Merged ERROR functionality
            end

            default: next_state = IDLE;
        endcase
    end

    assign done = done_reg;

endmodule
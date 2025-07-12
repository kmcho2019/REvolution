module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // One-hot state encoding
    localparam IDLE    = 3'b001;
    localparam RECEIVE = 3'b010;
    localparam STOP    = 3'b100;

    reg [2:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg done_reg;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            shift_reg <= 8'b0;
            done_reg <= 1'b0;
        end else begin
            state <= next_state;
            
            case (state)
                IDLE: begin
                    bit_count <= 3'b0;
                    done_reg <= 1'b0;
                end

                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]};  // Shift in LSB first
                    bit_count <= bit_count + 1;
                end

                STOP: begin
                    if (in) begin
                        done_reg <= (bit_count == 3'b111);  // Only set when full byte received
                    end
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                next_state = (~in) ? RECEIVE : IDLE;
            end

            RECEIVE: begin
                next_state = (bit_count == 3'b111) ? STOP : RECEIVE;
            end

            STOP: begin
                next_state = in ? IDLE : STOP;  // Wait for stop bit
            end

            default: next_state = IDLE;
        endcase
    end

    assign done = done_reg;

endmodule
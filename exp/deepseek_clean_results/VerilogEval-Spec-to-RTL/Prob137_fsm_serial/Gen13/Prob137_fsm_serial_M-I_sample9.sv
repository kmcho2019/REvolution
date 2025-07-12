module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // State encoding - reduced to 3 states
    localparam IDLE      = 2'b00;
    localparam RECEIVE   = 2'b01;
    localparam STOP_WAIT = 2'b10;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_shift;
    reg done_reg;
    reg in_reg;  // Input pipeline register

    // Terminal count signal
    wire bit_count_done = (bit_count == 3'b111);

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            data_shift <= 8'b0;
            done_reg <= 1'b0;
            in_reg <= 1'b1;
        end else begin
            in_reg <= in;  // Pipeline input register
            
            state <= next_state;
            done_reg <= 1'b0;  // Default to 0

            case (state)
                IDLE: begin
                    bit_count <= 3'b0;
                end

                RECEIVE: begin
                    if (!bit_count_done) begin
                        data_shift <= {in_reg, data_shift[7:1]};  // LSB first
                        bit_count <= bit_count + 1;
                    end
                end

                STOP_WAIT: begin
                    if (in_reg) begin  // Valid stop bit
                        done_reg <= 1'b1;
                    end
                end
            endcase
        end
    end

    // Combinational next state logic (simplified)
    always @(*) begin
        case (state)
            IDLE:      next_state = (~in_reg) ? RECEIVE : IDLE;
            RECEIVE:   next_state = bit_count_done ? STOP_WAIT : RECEIVE;
            STOP_WAIT: next_state = in_reg ? IDLE : STOP_WAIT;
            default:   next_state = IDLE;
        endcase
    end

    assign done = done_reg;

endmodule
module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output done
);

    // Binary encoded FSM states
    localparam IDLE   = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP   = 2'b10;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg done_reg;

    // Continuous assignment for done output
    assign done = done_reg;

    // State transition and data processing
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b111;
            shift_reg <= 0;
            out_byte <= 0;
            done_reg <= 0;
        end else begin
            state <= next_state;
            done_reg <= 0;  // Default to 0, set only in STOP state

            case (state)
                IDLE: begin
                    if (!in) begin
                        shift_reg <= 0;
                        bit_count <= 3'b111;
                    end
                end

                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count - 1;
                end

                STOP: begin
                    if (in) begin
                        out_byte <= shift_reg;
                        done_reg <= 1;
                    end
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        
        case (state)
            IDLE: begin
                if (!in) next_state = RECEIVE;
            end

            RECEIVE: begin
                if (bit_count == 0) next_state = STOP;
            end

            STOP: begin
                if (in) next_state = IDLE;
                else next_state = RECEIVE;  // Wait for stop bit
            end
        endcase
    end

endmodule
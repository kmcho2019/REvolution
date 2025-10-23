module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg done
);

    // Binary encoded FSM states
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP    = 2'b10;
    localparam ERROR   = 2'b11;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;    // counts 0 to 7 for 8 bits
    reg [7:0] data_reg;     // shift register for data bits

    wire shift_enable = (state == RECEIVE);

    // Next state logic
    always @(*) begin
        case(state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end
            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = STOP;
                else
                    next_state = RECEIVE;
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

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            data_reg <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // default no done pulse

            case(state)
                IDLE: begin
                    bit_count <= 3'd0;
                    data_reg <= 8'd0;
                end
                RECEIVE: begin
                    if (shift_enable) begin
                        data_reg <= {in, data_reg[7:1]};
                        bit_count <= bit_count + 1'b1;
                    end
                end
                STOP: begin
                    if (in == 1'b1)
                        done <= 1'b1; // pulse done one cycle
                end
                ERROR: begin
                    // Wait for stop bit 1, no updates
                end
            endcase
        end
    end

endmodule
module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

    // State encoding (binary)
    localparam IDLE    = 2'd0;
    localparam RECEIVE = 2'd1;
    localparam STOP    = 2'd2;
    localparam ERROR   = 2'd3;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;
    reg shift_en;

    // Next state logic
    always @(*) begin
        case(state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = RECEIVE; // start bit detected
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
            shift_en <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // Default done low each cycle

            case(state)
                IDLE: begin
                    bit_count <= 3'd0;
                    data_reg <= 8'd0;
                    shift_en <= 1'b0;
                end
                RECEIVE: begin
                    shift_en <= 1'b1;
                    bit_count <= bit_count + 1'b1;
                    // Shift right to insert new bit at MSB position
                    // Since data is LSB first, shift right and put new bit in MSB
                    data_reg <= {in, data_reg[7:1]};
                end
                STOP: begin
                    shift_en <= 1'b0;
                    if (in == 1'b1)
                        done <= 1'b1;
                end
                ERROR: begin
                    shift_en <= 1'b0;
                    // Remain here until stop bit (1) detected
                end
                default: begin
                    shift_en <= 1'b0;
                end
            endcase
        end
    end

endmodule
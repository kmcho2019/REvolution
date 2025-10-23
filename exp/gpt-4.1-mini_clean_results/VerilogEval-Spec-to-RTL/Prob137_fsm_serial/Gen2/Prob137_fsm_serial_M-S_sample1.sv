module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

    // State encoding
    localparam IDLE    = 2'd0;
    localparam RECEIVE = 2'd1;
    localparam STOP    = 2'd2;
    localparam ERROR   = 2'd3;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;

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
            done <= 1'b0; // default no pulse unless asserted below

            case(state)
                IDLE: begin
                    bit_count <= 3'd0;
                    data_reg <= 8'd0;
                end
                RECEIVE: begin
                    // Shift in LSB first: data_reg[0] gets first bit, then shift right inserting new bit at MSB
                    // This puts newest bit in MSB and oldest bit moves right, after 8 bits, data_reg holds received byte LSB at bit 0
                    data_reg <= {in, data_reg[7:1]};
                    bit_count <= bit_count + 1'b1;
                end
                STOP: begin
                    if (in == 1'b1) begin
                        done <= 1'b1; // one-cycle pulse after correct stop bit
                    end
                    // else done stays 0 and transition to ERROR handled by next_state logic
                end
                ERROR: begin
                    // wait for stop bit (line high) before going to IDLE, no other action
                end
            endcase
        end
    end

endmodule
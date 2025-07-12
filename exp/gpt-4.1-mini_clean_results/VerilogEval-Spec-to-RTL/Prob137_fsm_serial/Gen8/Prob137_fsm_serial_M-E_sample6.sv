module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

    // State encoding (one-hot for clarity and possible timing benefits)
    localparam WAIT_START    = 3'b001;
    localparam RECEIVE_BYTE  = 3'b010;
    localparam VALIDATE_STOP = 3'b100;

    reg [2:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;

    // Next state combinational logic
    always @(*) begin
        case(state)
            WAIT_START: begin
                if (in == 1'b0)
                    next_state = RECEIVE_BYTE;
                else
                    next_state = WAIT_START;
            end
            RECEIVE_BYTE: begin
                if (bit_count == 3'd7)
                    next_state = VALIDATE_STOP;
                else
                    next_state = RECEIVE_BYTE;
            end
            VALIDATE_STOP: begin
                if (in == 1'b1)
                    next_state = WAIT_START;
                else
                    next_state = VALIDATE_STOP; // Wait here until stop bit is correct
            end
            default: next_state = WAIT_START;
        endcase
    end

    // Sequential logic: state, counters, data shift, and output done pulse
    always @(posedge clk) begin
        if (reset) begin
            state <= WAIT_START;
            bit_count <= 3'd0;
            data_reg <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0;  // default done low

            case(state)
                WAIT_START: begin
                    bit_count <= 3'd0;
                    data_reg <= 8'd0;
                end
                RECEIVE_BYTE: begin
                    // Shift in LSB first: left-shift data_reg and input bit goes into bit 0
                    data_reg <= {in, data_reg[7:1]};
                    bit_count <= bit_count + 1'b1;
                end
                VALIDATE_STOP: begin
                    if (in == 1'b1)
                        done <= 1'b1; // One cycle pulse on valid stop bit
                end
            endcase
        end
    end

endmodule
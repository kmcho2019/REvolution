module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // Define states
    parameter IDLE = 2'b00;
    parameter RECEIVE = 2'b01;
    parameter STOP = 2'b10;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            shift_reg <= 8'b0;
            out_byte <= 8'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0;

            case (state)
                IDLE: begin
                    bit_count <= 3'b0;
                    if (in == 1'b0) begin
                        shift_reg <= 8'b0;
                    end
                end

                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 1;
                end

                STOP: begin
                    if (in == 1'b1) begin
                        out_byte <= shift_reg;
                        done <= 1'b1;
                    end
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = (in == 1'b0) ? RECEIVE : IDLE;
            RECEIVE: next_state = (bit_count == 3'b111) ? STOP : RECEIVE;
            STOP: next_state = (in == 1'b1) ? IDLE : STOP;
            default: next_state = IDLE;
        endcase
    end

endmodule
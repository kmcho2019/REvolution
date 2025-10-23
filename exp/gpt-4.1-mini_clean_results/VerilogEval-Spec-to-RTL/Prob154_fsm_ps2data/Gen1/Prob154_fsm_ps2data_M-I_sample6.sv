module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // State encoding
    typedef enum reg [1:0] {
        WAIT_FOR_START = 2'b00,
        BYTE_2         = 2'b01,
        BYTE_3         = 2'b10
    } state_t;

    reg [1:0] state, next_state;
    reg [23:0] shift_reg;
    reg shift_enable;

    always @(posedge clk) begin
        if (reset) begin
            state <= WAIT_FOR_START;
            shift_reg <= 24'b0;
            out_bytes <= 24'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // Default done deassert

            if (shift_enable) begin
                shift_reg <= {shift_reg[15:0], in};
            end

            if (state == BYTE_3) begin
                done <= 1'b1;
                out_bytes <= {shift_reg[23:16], shift_reg[15:8], in};
            end
        end
    end

    always @(*) begin
        shift_enable = 1'b0;
        case(state)
            WAIT_FOR_START: begin
                if (in[3]) begin
                    next_state = BYTE_2;
                    shift_enable = 1'b1; // Capture first byte
                end else
                    next_state = WAIT_FOR_START;
            end
            BYTE_2: begin
                next_state = BYTE_3;
                shift_enable = 1'b1; // Capture second byte
            end
            BYTE_3: begin
                next_state = WAIT_FOR_START;
                shift_enable = 1'b0; // Do not shift on done cycle because last byte handled separately
            end
            default: begin
                next_state = WAIT_FOR_START;
                shift_enable = 1'b0;
            end
        endcase
    end

endmodule
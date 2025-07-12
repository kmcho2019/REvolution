module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // State encoding - binary encoded
    localparam IDLE  = 2'b00,
               BYTE2 = 2'b01,
               BYTE3 = 2'b10;

    reg [1:0] state, next_state;
    reg [23:0] shift_reg;
    reg shift_en;

    // Next state and control signals
    always @(*) begin
        done = 1'b0;
        shift_en = 1'b0;
        next_state = state;
        case(state)
            IDLE: begin
                if (in[3]) begin
                    shift_en = 1'b1;
                    next_state = BYTE2;
                end
            end
            BYTE2: begin
                shift_en = 1'b1;
                next_state = BYTE3;
            end
            BYTE3: begin
                shift_en = 1'b1;
                done = 1'b1;
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic for state and datapath
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 24'd0;
            out_bytes <= 24'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            if (shift_en) begin
                // Shift left 8 bits and insert new byte at LSB
                shift_reg <= {shift_reg[15:0], in};
            end
            // Register done and out_bytes when done asserted
            if (done) begin
                out_bytes <= shift_reg;
            end
        end
    end

endmodule
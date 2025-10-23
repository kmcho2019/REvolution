module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // One-hot encoded states
    localparam IDLE  = 3'b001,
               BYTE2 = 3'b010,
               BYTE3 = 3'b100;

    reg [2:0] state, next_state;

    // Shift register to hold 3 bytes, loading MSByte first
    reg [23:0] message_reg;
    reg load_enable;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            message_reg <= 24'd0;
            out_bytes <= 24'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            // Load bytes only when load_enable is asserted
            if (load_enable) begin
                // Shift in new byte to the right, preserving order:
                // on first byte: message_reg[23:16] = in
                // second byte: [15:8], third byte: [7:0]
                case(state)
                    IDLE:  message_reg[23:16] <= in;       // byte 1
                    BYTE2: message_reg[15:8]  <= in;       // byte 2
                    BYTE3: message_reg[7:0]   <= in;       // byte 3
                    default: ;
                endcase
            end

            // Output update and done signal timing
            // done asserted only for one clock cycle immediately after receiving byte 3
            done <= (state == BYTE3);
            if (state == BYTE3)
                out_bytes <= message_reg;
        end
    end

    // Next state logic combinational
    always @(*) begin
        load_enable = 1'b0;
        case(state)
            IDLE: begin
                if (in[3])
                    next_state = BYTE2;
                else
                    next_state = IDLE;
            end
            BYTE2: next_state = BYTE3;
            BYTE3: next_state = IDLE;
            default: next_state = IDLE;
        endcase

        // Enable load if transitioning from IDLE to BYTE2 or in BYTE2 or BYTE3 states
        // Actually, we load only when we are in IDLE and input's in[3] is 1 (start message)
        // and also in BYTE2 and BYTE3 states to capture byte2 and byte3
        load_enable = ( (state == IDLE && in[3]) || (state == BYTE2) || (state == BYTE3) );
    end

endmodule
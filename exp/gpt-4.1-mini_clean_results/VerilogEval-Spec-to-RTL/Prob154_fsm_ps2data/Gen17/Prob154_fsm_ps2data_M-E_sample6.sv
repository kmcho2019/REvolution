module TopModule(
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output reg       done
);

    // State encoding
    typedef enum logic [1:0] {
        SEARCH = 2'b00,
        BYTE1  = 2'b01,
        BYTE2  = 2'b10,
        BYTE3  = 2'b11
    } state_t;

    state_t state, next_state;
    reg [23:0] message_reg;

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state       <= SEARCH;
            message_reg <= 24'd0;
            out_bytes   <= 24'd0;
            done        <= 1'b0;
        end else begin
            state <= next_state;
            done  <= 1'b0; // default done low

            case (state)
                SEARCH: begin
                    if (in[3]) begin
                        // Start collecting message, load first byte in LSB position
                        message_reg <= {16'd0, in};
                    end
                end
                BYTE1: begin
                    // Shift message left 8 bits and add next byte at LSB
                    message_reg <= {message_reg[15:0], in};
                end
                BYTE2: begin
                    // Shift message left 8 bits and add last byte at LSB
                    message_reg <= {message_reg[15:0], in};
                end
                BYTE3: begin
                    // Completed message, update out_bytes and signal done
                    out_bytes   <= message_reg;
                    done        <= 1'b1;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            SEARCH: next_state = (in[3]) ? BYTE1 : SEARCH;
            BYTE1:  next_state = BYTE2;
            BYTE2:  next_state = BYTE3;
            BYTE3:  next_state = SEARCH;
        endcase
    end

endmodule
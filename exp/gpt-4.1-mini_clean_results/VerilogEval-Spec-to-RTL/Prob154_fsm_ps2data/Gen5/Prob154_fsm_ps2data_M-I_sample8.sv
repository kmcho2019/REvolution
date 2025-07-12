module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // States encoding
    localparam IDLE  = 2'd0;
    localparam BYTE1 = 2'd1;
    localparam BYTE2 = 2'd2;

    reg [1:0] state, next_state;
    reg [7:0] byte1, byte2;

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic with in[3] check only in IDLE
    always @(*) begin
        case(state)
            IDLE: begin
                if (in[3])
                    next_state = BYTE1;
                else
                    next_state = IDLE;
            end
            BYTE1: next_state = BYTE2;
            BYTE2: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Byte registers update only when valid: in IDLE capture byte1 if in[3], in BYTE1 capture byte2
    // No byte3 register needed since third byte is directly from input for output concatenation
    always @(posedge clk) begin
        if (reset) begin
            byte1 <= 8'd0;
            byte2 <= 8'd0;
            out_bytes <= 24'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // default no done

            case(state)
                IDLE: begin
                    if (in[3]) begin
                        byte1 <= in;
                    end
                end
                BYTE1: begin
                    byte2 <= in;
                end
                BYTE2: begin
                    // On BYTE2, the third byte received is 'in'
                    // Output concatenated message and assert done
                    out_bytes <= {byte1, byte2, in};
                    done <= 1'b1;
                end
                default: ;
            endcase
        end
    end

endmodule
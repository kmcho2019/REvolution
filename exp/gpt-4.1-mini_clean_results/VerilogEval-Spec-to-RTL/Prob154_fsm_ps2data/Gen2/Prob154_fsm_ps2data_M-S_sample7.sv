module TopModule (
    input         clk,
    input         reset,
    input  [7:0]  in,
    output reg [23:0] out_bytes,
    output reg        done
);

    // States
    localparam WAIT   = 2'd0;
    localparam BYTE2  = 2'd1;
    localparam BYTE3  = 2'd2;

    reg [1:0] state, next_state;
    reg [23:0] message;

    always @(posedge clk) begin
        if (reset) begin
            state <= WAIT;
            message <= 24'd0;
            out_bytes <= 24'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0;
            case (state)
                WAIT: begin
                    if (in[3]) begin
                        // Store first byte in highest byte of message
                        message <= {in, 16'd0};
                    end
                end
                BYTE2: begin
                    // Shift message left by 8 bits and insert new byte
                    message <= {message[15:0], in};
                end
                BYTE3: begin
                    message <= {message[15:0], in};
                    out_bytes <= {message[15:0], in};
                    done <= 1'b1;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            WAIT:  next_state = (in[3]) ? BYTE2 : WAIT;
            BYTE2: next_state = BYTE3;
            BYTE3: next_state = WAIT;
            default: next_state = WAIT;
        endcase
    end

endmodule
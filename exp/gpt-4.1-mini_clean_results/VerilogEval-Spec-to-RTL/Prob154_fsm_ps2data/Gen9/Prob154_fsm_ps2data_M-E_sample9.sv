module TopModule (
    input         clk,
    input         reset,
    input  [7:0]  in,
    output reg [23:0] out_bytes,
    output reg    done
);

    // One-hot FSM states
    localparam IDLE  = 4'b0001;
    localparam BYTE1 = 4'b0010;
    localparam BYTE2 = 4'b0100;
    localparam DONE  = 4'b1000;

    reg [3:0] state, next_state;

    // Byte registers
    reg [7:0] b1, b2, b3;

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            b1 <= 8'd0;
            b2 <= 8'd0;
            b3 <= 8'd0;
            out_bytes <= 24'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            // Update bytes only when in appropriate states
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    if (in[3]) begin
                        b1 <= in; // Found first byte with in[3]=1
                    end
                end
                BYTE1: begin
                    b2 <= in;
                    done <= 1'b0;
                end
                BYTE2: begin
                    b3 <= in;
                    done <= 1'b0;
                end
                DONE: begin
                    done <= 1'b1;
                    out_bytes <= {b1, b2, b3};
                end
                default: done <= 1'b0;
            endcase

            // Clear done after pulse cycle
            if (state != DONE)
                done <= 1'b0;
        end
    end

    // Next-state logic
    always @(*) begin
        next_state = IDLE;
        case (state)
            IDLE:  next_state = in[3] ? BYTE1 : IDLE;
            BYTE1: next_state = BYTE2;
            BYTE2: next_state = DONE;
            DONE:  next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

endmodule
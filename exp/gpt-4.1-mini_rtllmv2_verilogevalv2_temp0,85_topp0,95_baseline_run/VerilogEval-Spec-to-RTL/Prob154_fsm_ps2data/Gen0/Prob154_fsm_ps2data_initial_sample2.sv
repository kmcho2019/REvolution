module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output reg       done
);

    // State encoding
    typedef enum reg [0:0] {IDLE=1'b0, COLLECT=1'b1} state_t;
    reg state_t state, next_state;

    reg [1:0] byte_count;  // counts 0..2 bytes collected in COLLECT

    reg [7:0] byte0;
    reg [7:0] byte1;
    reg [7:0] byte2;

    // Next state and outputs combinational logic
    always @(*) begin
        // Default assignments
        next_state = state;
        done = 1'b0;

        case(state)
            IDLE: begin
                if (in[3]) begin
                    // Found start byte with in[3]=1
                    next_state = COLLECT;
                end
            end

            COLLECT: begin
                if (byte_count == 2) begin
                    done = 1'b1; // After receiving 3 bytes
                    next_state = IDLE;
                end
            end
        endcase
    end

    // Sequential logic for state and data registers
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            byte_count <= 2'd0;
            byte0 <= 8'b0;
            byte1 <= 8'b0;
            byte2 <= 8'b0;
            out_bytes <= 24'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    done <= 1'b0;
                    byte_count <= 2'd0;
                    if (in[3]) begin
                        byte0 <= in;
                        byte_count <= 2'd0; // first byte stored, count=0 means first byte
                    end
                end

                COLLECT: begin
                    done <= 1'b0;
                    if (byte_count == 0) begin
                        byte1 <= in;
                        byte_count <= 2'd1;
                    end else if (byte_count == 1) begin
                        byte2 <= in;
                        byte_count <= 2'd2;
                    end else if (byte_count == 2) begin
                        // done signal generated combinationally, so output is latched here
                        out_bytes <= {byte0, byte1, byte2};
                        done <= 1'b1;
                        byte_count <= 2'd0;
                    end
                end
            endcase

            // When transitioning from COLLECT with byte_count=2 done has been asserted combinationally.
            // We need to latch out_bytes and done at that cycle, so done is also assigned above.

            // However, to meet "done in the cycle immediately after the third byte received" and 
            // out_bytes valid when done asserted, we latch out_bytes and done here.
            // The third byte arrives when byte_count==1, then byte_count==2 triggers done next cycle.

            // Adjust logic for correct timing:
            // When byte_count is 1 and next input comes, that is third byte. So when byte_count==1 and in arrives,
            // store byte2 <= in, byte_count=2, then next cycle done=1 and output assembled.

            // So modify logic to latch out_bytes and done when byte_count==2.

            if(state == COLLECT && byte_count == 2) begin
                out_bytes <= {byte0, byte1, byte2};
                done <= 1'b1;
                // After done, FSM returns to IDLE next cycle as per next_state
            end

        end
    end

endmodule
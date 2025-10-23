module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output reg       done
);

    // Define states
    localparam WAIT_START = 2'd0;
    localparam GOT_BYTE1  = 2'd1;
    localparam GOT_BYTE2  = 2'd2;
    localparam DONE_SIGNAL= 2'd3;

    reg [1:0] state, next_state;
    reg [7:0] byte1, byte2, byte3;

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            WAIT_START: begin
                if(in[3] == 1'b1)
                    next_state = GOT_BYTE1;
                else
                    next_state = WAIT_START;
            end
            GOT_BYTE1: begin
                next_state = GOT_BYTE2;
            end
            GOT_BYTE2: begin
                next_state = DONE_SIGNAL;
            end
            DONE_SIGNAL: begin
                // After signaling done, go back to waiting for next message start
                next_state = WAIT_START;
            end
            default: next_state = WAIT_START;
        endcase
    end

    // Sequential logic: state transitions and data capture
    always @(posedge clk) begin
        if(reset) begin
            state <= WAIT_START;
            byte1 <= 8'd0;
            byte2 <= 8'd0;
            byte3 <= 8'd0;
            out_bytes <= 24'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case(next_state)
                WAIT_START: begin
                    // Clear done and output here; do not update bytes
                    done <= 1'b0;
                    out_bytes <= 24'd0;
                end
                GOT_BYTE1: begin
                    byte1 <= in; // first byte (in[3]==1)
                    done <= 1'b0;
                end
                GOT_BYTE2: begin
                    byte2 <= in;
                    done <= 1'b0;
                end
                DONE_SIGNAL: begin
                    byte3 <= in;
                    // Assemble output bytes as per spec:
                    // out_bytes[23:16] = first byte,
                    // out_bytes[15:8]  = second byte,
                    // out_bytes[7:0]   = third byte
                    out_bytes <= {byte1, byte2, in};
                    done <= 1'b1; // Assert done for one cycle after receiving third byte
                end
                default: begin
                    done <= 1'b0;
                end
            endcase
        end
    end

endmodule
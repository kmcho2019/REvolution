module TopModule (
    input         clk,
    input         reset,
    input  [7:0]  in,
    output reg [23:0] out_bytes,
    output reg       done
);

    // FSM states encoding
    localparam WAIT_SYNC = 2'd0;
    localparam BYTE2     = 2'd1;
    localparam BYTE3     = 2'd2;

    reg [1:0] state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            state     <= WAIT_SYNC;
            out_bytes <= 24'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;
            done  <= 1'b0; // default done low

            case (state)
                WAIT_SYNC: begin
                    if (in[3]) begin
                        out_bytes[23:16] <= in; // first byte
                        done <= 1'b0;
                    end
                end
                BYTE2: begin
                    out_bytes[15:8] <= in;   // second byte
                end
                BYTE3: begin
                    out_bytes[7:0] <= in;    // third byte
                    done <= 1'b1;            // signal done on third byte
                end
            endcase
        end
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
            WAIT_SYNC: begin
                if (in[3])
                    next_state = BYTE2;
                else
                    next_state = WAIT_SYNC;
            end
            BYTE2:  next_state = BYTE3;
            BYTE3:  next_state = WAIT_SYNC;
            default: next_state = WAIT_SYNC;
        endcase
    end

endmodule
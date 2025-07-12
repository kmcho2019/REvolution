module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output reg       done
);

    // State encoding using one-hot style for clarity
    localparam WAIT_SYNC = 2'd0;
    localparam BYTE2     = 2'd1;
    localparam BYTE3     = 2'd2;

    reg [1:0] state, next_state;
    reg [7:0] byte1, byte2, byte3;

    // Next state logic: combinational
    always @(*) begin
        case(state)
            WAIT_SYNC: next_state = in[3] ? BYTE2 : WAIT_SYNC;
            BYTE2:     next_state = BYTE3;
            BYTE3:     next_state = WAIT_SYNC;
            default:   next_state = WAIT_SYNC;
        endcase
    end

    // Sequential logic: state and bytes capturing
    always @(posedge clk) begin
        if (reset) begin
            state     <= WAIT_SYNC;
            byte1     <= 8'd0;
            byte2     <= 8'd0;
            byte3     <= 8'd0;
            out_bytes <= 24'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;
            done  <= 1'b0; // default no done

            case (next_state)
                WAIT_SYNC: begin
                    // When entering WAIT_SYNC, no done or output update
                    // Resetting bytes not strictly necessary but clearer
                end
                BYTE2: begin
                    if (state == WAIT_SYNC && in[3]) 
                        byte1 <= in; // capture first byte on sync detect
                    else
                        byte2 <= in; // capture second byte
                end
                BYTE3: begin
                    byte3 <= in; // capture third byte
                end
                default: ;
            endcase

            // Assert done and update out_bytes only on BYTE3 state (current state)
            if (state == BYTE3) begin
                done <= 1'b1;
                out_bytes <= {byte1, byte2, byte3};
            end
        end
    end

endmodule
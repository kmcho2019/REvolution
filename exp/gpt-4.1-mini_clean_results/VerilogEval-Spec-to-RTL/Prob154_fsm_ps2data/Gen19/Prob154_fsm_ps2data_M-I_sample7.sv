module TopModule (
    input         clk,
    input         reset,
    input  [7:0]  in,
    output reg [23:0] out_bytes,
    output reg       done
);

    // FSM encoding: 2-bit binary
    localparam WAIT_SYNC = 2'b00;
    localparam BYTE2     = 2'b01;
    localparam BYTE3     = 2'b10;

    reg [1:0] state, next_state;
    reg [1:0] byte_count;

    // Shift register style storage of bytes:
    // After sync byte detected (with in[3]==1), out_bytes[23:16] <= in
    // Then shift down the previous bytes by 8 bits at each next byte
    // out_bytes[23:0] = {byte1, byte2, byte3}

    // FSM state register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= WAIT_SYNC;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case(state)
            WAIT_SYNC: next_state = (in[3]) ? BYTE2 : WAIT_SYNC;
            BYTE2:     next_state = BYTE3;
            BYTE3:     next_state = WAIT_SYNC;
            default:   next_state = WAIT_SYNC;
        endcase
    end

    // Datapath and done generation
    always @(posedge clk) begin
        if (reset) begin
            out_bytes <= 24'b0;
            done <= 1'b0;
            byte_count <= 2'b0;
        end else begin
            done <= 1'b0; // default done low

            case(state)
                WAIT_SYNC: begin
                    byte_count <= 2'b1;
                    if (in[3]) begin
                        // Start of message detected, load first byte into MSB of out_bytes
                        out_bytes <= {in, 16'b0};
                    end
                end
                BYTE2: begin
                    byte_count <= 2'b10;
                    // Shift out_bytes left by 8 bits and load new byte in lower bits
                    out_bytes <= {out_bytes[15:0], in};
                end
                BYTE3: begin
                    byte_count <= 2'b11;
                    out_bytes <= {out_bytes[15:0], in};
                    done <= 1'b1;
                end
                default: begin
                    byte_count <= 2'b0;
                    done <= 1'b0;
                end
            endcase
        end
    end

endmodule
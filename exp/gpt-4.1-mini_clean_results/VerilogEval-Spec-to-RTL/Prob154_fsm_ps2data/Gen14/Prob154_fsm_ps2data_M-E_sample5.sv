module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // One-hot state encoding
    localparam IDLE  = 4'b0001;
    localparam BYTE1 = 4'b0010;
    localparam BYTE2 = 4'b0100;
    localparam BYTE3 = 4'b1000;

    reg [3:0] state, next_state;

    reg [7:0] byte1, byte2, byte3;

    // Next state logic combinational
    always @(*) begin
        case(state)
            IDLE:
                if (in[3])
                    next_state = BYTE2;
                else
                    next_state = IDLE;
            BYTE2:
                next_state = BYTE3;
            BYTE3:
                next_state = IDLE;
            default:
                next_state = IDLE;
        endcase
    end

    // Sequential state and data update
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            byte1     <= 8'b0;
            byte2     <= 8'b0;
            byte3     <= 8'b0;
            out_bytes <= 24'b0;
            done      <= 1'b0;
        end else begin
            state <= next_state;
            done  <= 1'b0; // default no done

            case(state)
                IDLE: begin
                    if (in[3]) begin
                        byte1 <= in;
                    end
                end
                BYTE2: begin
                    byte2 <= in;
                end
                BYTE3: begin
                    byte3 <= in;
                    out_bytes <= {byte1, byte2, in};
                    done <= 1'b1;
                end
            endcase
        end
    end

endmodule
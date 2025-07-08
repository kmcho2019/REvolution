module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output reg   done
);

    // State encoding
    localparam IDLE  = 2'd0;
    localparam BYTE1 = 2'd1;
    localparam BYTE2 = 2'd2;

    reg [1:0] state, next_state;

    // Storage for bytes
    reg [7:0] byte1, byte2, byte3;

    // Synchronous state and data update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            byte1 <= 8'b0;
            byte2 <= 8'b0;
            byte3 <= 8'b0;
            out_bytes <= 24'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            // Default done low, will be set in BYTE2 state after third byte
            done <= 1'b0;

            case(state)
                IDLE: begin
                    // Wait for byte with in[3]==1
                    if (in[3]) begin
                        byte1 <= in;
                    end
                end
                BYTE1: begin
                    byte2 <= in;
                end
                BYTE2: begin
                    byte3 <= in;
                    out_bytes <= {byte1, byte2, in};
                    done <= 1'b1;  // Assert done at reception of 3rd byte
                end
            endcase
        end
    end

    // Next state logic combinational
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

endmodule
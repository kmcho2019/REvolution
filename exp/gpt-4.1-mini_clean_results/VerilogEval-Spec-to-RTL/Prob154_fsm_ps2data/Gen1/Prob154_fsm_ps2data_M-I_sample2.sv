module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // State encoding
    localparam WAIT_FOR_START = 2'd0;
    localparam BYTE_2        = 2'd1;
    localparam BYTE_3        = 2'd2;
    localparam DONE_STATE    = 2'd3; // output done signal for one cycle

    reg [1:0] state, next_state;

    // Registers to hold the three bytes
    reg [7:0] byte1, byte2, byte3;

    // Combinational logic for next_state
    always @(*) begin
        case (state)
            WAIT_FOR_START: 
                if (in[3])       next_state = BYTE_2;
                else             next_state = WAIT_FOR_START;
            BYTE_2:              next_state = BYTE_3;
            BYTE_3:              next_state = DONE_STATE;
            DONE_STATE:          next_state = WAIT_FOR_START;
            default:             next_state = WAIT_FOR_START;
        endcase
    end

    // Sequential logic for state, registers, done, and output
    always @(posedge clk) begin
        if (reset) begin
            state     <= WAIT_FOR_START;
            done      <= 1'b0;
            out_bytes <= 24'b0;
            byte1     <= 8'b0;
            byte2     <= 8'b0;
            byte3     <= 8'b0;
        end else begin
            state <= next_state;
            done  <= 1'b0; // default done low

            case (state)
                WAIT_FOR_START: begin
                    if (in[3]) begin
                        byte1 <= in;
                    end
                end
                BYTE_2: begin
                    byte2 <= in;
                end
                BYTE_3: begin
                    byte3 <= in;
                end
                DONE_STATE: begin
                    done <= 1'b1;
                    out_bytes <= {byte1, byte2, byte3};
                end
            endcase
        end
    end

endmodule
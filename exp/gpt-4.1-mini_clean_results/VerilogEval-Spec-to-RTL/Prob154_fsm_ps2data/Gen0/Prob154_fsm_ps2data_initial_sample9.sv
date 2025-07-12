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

    reg [1:0] state, next_state;
    reg [7:0] byte1, byte2, byte3;

    // State transition and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= WAIT_FOR_START;
            done <= 1'b0;
            out_bytes <= 24'b0;
            byte1 <= 8'b0;
            byte2 <= 8'b0;
            byte3 <= 8'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // default done low unless set below

            case (state)
                WAIT_FOR_START: begin
                    // look for in[3] == 1
                    if (in[3] == 1'b1) begin
                        byte1 <= in;
                        next_state <= BYTE_2;
                    end else begin
                        next_state <= WAIT_FOR_START;
                    end
                end
                BYTE_2: begin
                    byte2 <= in;
                    next_state <= BYTE_3;
                end
                BYTE_3: begin
                    byte3 <= in;
                    // Output message and signal done on this cycle
                    out_bytes <= {byte1, byte2, in};
                    done <= 1'b1;
                    next_state <= WAIT_FOR_START;
                end
                default: begin
                    next_state <= WAIT_FOR_START;
                end
            endcase
        end
    end

endmodule
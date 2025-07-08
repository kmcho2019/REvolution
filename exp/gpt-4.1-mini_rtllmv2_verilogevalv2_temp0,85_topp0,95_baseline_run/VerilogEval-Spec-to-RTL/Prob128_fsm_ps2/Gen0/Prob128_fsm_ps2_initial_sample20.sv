module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] state;

    localparam WAIT_START = 2'd0;
    localparam BYTE1 = 2'd1;
    localparam BYTE2 = 2'd2;

    always @(posedge clk) begin
        if (reset) begin
            state <= WAIT_START;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // default done to 0, pulse for one cycle only
            case (state)
                WAIT_START: begin
                    if (in[3]) begin
                        state <= BYTE1;
                    end else begin
                        state <= WAIT_START;
                    end
                end
                BYTE1: begin
                    // second byte of message
                    state <= BYTE2;
                end
                BYTE2: begin
                    // third byte of message received
                    done <= 1'b1;
                    state <= WAIT_START;
                end
                default: state <= WAIT_START;
            endcase
        end
    end

endmodule
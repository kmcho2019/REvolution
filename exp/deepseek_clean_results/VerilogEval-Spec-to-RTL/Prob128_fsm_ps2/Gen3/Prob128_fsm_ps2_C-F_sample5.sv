module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] state;

    // State definitions
    localparam WAIT_START = 2'b00;
    localparam GOT_BYTE1  = 2'b01;
    localparam GOT_BYTE2  = 2'b10;
    localparam MSG_DONE   = 2'b11;

    always @(posedge clk) begin
        if (reset) begin
            state <= WAIT_START;
            done <= 1'b0;
        end else begin
            case (state)
                WAIT_START: begin
                    done <= 1'b0;
                    if (in[3]) begin
                        state <= GOT_BYTE1;
                    end
                end
                GOT_BYTE1: begin
                    state <= GOT_BYTE2;
                end
                GOT_BYTE2: begin
                    state <= MSG_DONE;
                end
                MSG_DONE: begin
                    done <= 1'b1;
                    if (in[3]) begin
                        state <= GOT_BYTE1;
                    end else begin
                        state <= WAIT_START;
                    end
                end
            endcase
        end
    end

endmodule
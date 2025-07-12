module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    // State encoding using 2-bit binary states
    localparam IDLE  = 2'd0;
    localparam BYTE1 = 2'd1;
    localparam BYTE2 = 2'd2;

    reg [1:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
        end else begin
            done <= 1'b0;  // Default done low, pulse only after third byte

            case(state)
                IDLE: begin
                    if (in[3])
                        state <= BYTE1;
                    else
                        state <= IDLE;
                end

                BYTE1: begin
                    state <= BYTE2;
                end

                BYTE2: begin
                    state <= IDLE;
                    done <= 1'b1;  // Pulse done one cycle after third byte received
                end

                default: begin
                    state <= IDLE;
                    done <= 1'b0;
                end
            endcase
        end
    end

endmodule
module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    // One-hot state encoding
    reg [2:0] state;
    localparam IDLE  = 3'b001;
    localparam BYTE1 = 3'b010;
    localparam BYTE2 = 3'b100;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    if (in[3]) begin
                        state <= BYTE1;
                    end
                end
                BYTE1: begin
                    state <= BYTE2;
                end
                BYTE2: begin
                    state <= IDLE;
                    done <= 1'b1;
                end
                default: state <= IDLE;
            endcase
        end
    end

endmodule
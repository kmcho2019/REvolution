module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output reg done
);

    // One-hot state encoding
    localparam IDLE  = 3'b001;
    localparam BYTE1 = 3'b010;
    localparam BYTE2 = 3'b100;

    reg [2:0] state;
    reg [7:0] byte1, byte2, byte3;

    // Combinational output assignment
    assign out_bytes = done ? {byte1, byte2, byte3} : 24'bx;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
            byte1 <= 8'bx;
            byte2 <= 8'bx;
            byte3 <= 8'bx;
        end else begin
            done <= 1'b0; // Default assignment

            case (state)
                IDLE: begin
                    if (in[3]) begin
                        byte1 <= in;
                        state <= BYTE1;
                    end
                end

                BYTE1: begin
                    byte2 <= in;
                    state <= BYTE2;
                end

                BYTE2: begin
                    byte3 <= in;
                    done <= 1'b1;
                    state <= IDLE;
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule
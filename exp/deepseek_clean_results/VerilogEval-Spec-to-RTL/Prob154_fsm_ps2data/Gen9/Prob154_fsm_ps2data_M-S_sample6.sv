module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [1:0] state;
    localparam IDLE  = 2'b00;
    localparam BYTE1 = 2'b01;
    localparam BYTE2 = 2'b10;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 0;
        end else begin
            case (state)
                IDLE: if (in[3]) begin
                    out_bytes[23:16] <= in;
                    state <= BYTE1;
                    done <= 0;
                end
                BYTE1: begin
                    out_bytes[15:8] <= in;
                    state <= BYTE2;
                end
                BYTE2: begin
                    out_bytes[7:0] <= in;
                    state <= IDLE;
                    done <= 1;
                end
            endcase
        end
    end

endmodule
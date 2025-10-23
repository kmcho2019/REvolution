module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state; // idle (0), first byte (1), second byte (2), third byte (3)
reg [23:0] bytes;
reg [1:0] count;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        bytes <= 0;
        count <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // idle
                if (in[3] == 1) begin
                    state <= 1;
                    bytes[7:0] <= in;
                    count <= 1;
                end
            end
            1: begin // first byte
                state <= 2;
                bytes[15:8] <= in;
                count <= 2;
            end
            2: begin // second byte
                state <= 3;
                bytes[23:16] <= in;
                count <= 3;
            end
            3: begin // third byte
                done <= 1;
                state <= 0;
            end
            default: begin
                state <= 0;
            end
        endcase
        if (count == 3) begin
            done <= 1;
            out_bytes <= bytes;
        end else begin
            done <= 0;
        end
    end
end

endmodule
module TopModule (
    input  clk,
    input  reset,
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [1:0] state; // Idle, Byte1, Byte2, Done
reg [7:0] byte1, byte2, byte3;

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Idle
        out_bytes <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // Idle
                if (in[3] == 1) begin
                    state <= 1; // Byte1
                    byte1 <= in;
                end
            end
            1: begin // Byte1
                state <= 2; // Byte2
                byte2 <= in;
            end
            2: begin // Byte2
                state <= 3; // Done
                byte3 <= in;
            end
            3: begin // Done
                out_bytes <= {byte1, byte2, byte3};
                done <= 1;
                state <= 0; // Idle
            end
        endcase
    end
end

always @(posedge clk) begin
    if (reset) begin
        done <= 0;
    end else if (state == 3) begin // Done
        done <= 1;
    end else begin
        done <= 0;
    end
end

endmodule
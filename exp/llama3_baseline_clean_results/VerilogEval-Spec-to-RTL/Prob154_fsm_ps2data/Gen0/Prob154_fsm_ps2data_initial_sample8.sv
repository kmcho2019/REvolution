module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state; // idle (0), byte1 (1), byte2 (2), byte3 (3)
reg [7:0] byte1, byte2, byte3;
reg [23:0] out_bytes_reg;
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        out_bytes_reg <= 0;
        done_reg <= 0;
    end else begin
        case (state)
            0: begin // idle
                if (in[3]) begin
                    byte1 <= in;
                    state <= 1;
                end
            end
            1: begin // byte1
                byte2 <= in;
                state <= 2;
            end
            2: begin // byte2
                byte3 <= in;
                state <= 3;
            end
            3: begin // byte3
                out_bytes_reg <= {byte1, byte2, byte3};
                done_reg <= 1;
                state <= 0;
            end
        endcase
        if (state != 3) begin
            done_reg <= 0;
        end
    end
end

assign out_bytes = out_bytes_reg;
assign done = done_reg;

endmodule
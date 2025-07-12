module TopModule(
    input  clk,
    input  reset,
    input  [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state; // 0: IDLE, 1: BYTE1, 2: BYTE2, 3: BYTE3 (not used)
reg [7:0] byte1, byte2, byte3;
reg [23:0] out_bytes_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0;
        out_bytes_reg <= 0;
        byte1 <= 0;
        byte2 <= 0;
        byte3 <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (in[3]) begin
                    byte1 <= in;
                    state <= 1;
                end
            end
            1: begin // BYTE1
                byte2 <= in;
                state <= 2;
            end
            2: begin // BYTE2
                byte3 <= in;
                state <= 0; // transition back to IDLE after BYTE3
                out_bytes_reg <= {byte1, byte2, byte3};
            end
            default: state <= 0;
        endcase
    end
end

assign out_bytes = out_bytes_reg;
assign done = (state == 0 && out_bytes_reg != 0);

endmodule
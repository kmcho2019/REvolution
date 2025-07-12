module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state; // IDLE, BYTE1, BYTE2, BYTE3
reg [7:0] byte1, byte2, byte3;
reg [23:0] out_bytes_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        out_bytes_reg <= 24'd0;
        done <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (in[3]) begin
                    state <= 1; // BYTE1
                    byte1 <= in;
                end
            end
            1: begin // BYTE1
                state <= 2; // BYTE2
                byte2 <= in;
            end
            2: begin // BYTE2
                state <= 0; // IDLE
                byte3 <= in;
                out_bytes_reg <= {byte1, byte2, byte3};
                done <= 1;
            end
            default: state <= 0; // IDLE
        endcase
    end
end

assign out_bytes = out_bytes_reg;
assign done = (state == 2)? 1 : 0;

endmodule
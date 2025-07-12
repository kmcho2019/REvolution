module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [1:0] state_reg; // Idle (0), Byte1 (1), Byte2 (2)
reg [7:0] byte1, byte2, byte3;
reg [23:0] out_bytes_reg;

always @(*) begin
    case (state_reg)
        0: begin // Idle
            if (in[3]) begin
                state_reg = 1;
                byte1 = in;
            end else begin
                state_reg = 0;
            end
        end
        1: begin // Byte1
            state_reg = 2;
            byte2 = in;
        end
        2: begin // Byte2
            state_reg = 0;
            byte3 = in;
            done = 1;
        end
        default: begin
            state_reg = 0;
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state_reg <= 0;
        out_bytes_reg <= 0;
        done <= 0;
    end else begin
        if (state_reg == 2) begin // Byte2
            out_bytes_reg <= {byte1, byte2, byte3};
        end
        state_reg <= state_reg;
        out_bytes <= out_bytes_reg;
        if (done) begin
            done <= 0;
        end
    end
end

endmodule
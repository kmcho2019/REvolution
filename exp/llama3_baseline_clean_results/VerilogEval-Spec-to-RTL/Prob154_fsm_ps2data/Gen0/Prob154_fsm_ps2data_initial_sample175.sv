module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [23:0] out_bytes_reg;
reg done_reg;
reg [1:0] state_reg;
reg [7:0] byte1_reg;
reg [7:0] byte2_reg;

always @(posedge clk) begin
    if (reset) begin
        state_reg <= 2'b00;
        out_bytes_reg <= 24'b0;
        done_reg <= 1'b0;
        byte1_reg <= 8'b0;
        byte2_reg <= 8'b0;
    end else begin
        case (state_reg)
            2'b00: begin // IDLE state
                if (in[3]) begin
                    byte1_reg <= in;
                    state_reg <= 2'b01;
                end
            end
            2'b01: begin // BYTE1 state
                byte2_reg <= in;
                state_reg <= 2'b10;
            end
            2'b10: begin // BYTE2 state
                out_bytes_reg <= {byte1_reg, byte2_reg, in};
                state_reg <= 2'b00;
                done_reg <= 1'b1;
            end
        endcase
    end
end

always @(posedge clk) begin
    out_bytes <= out_bytes_reg;
    done <= done_reg && (state_reg == 2'b00);
end

endmodule
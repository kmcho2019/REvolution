module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output [23:0] out_bytes,
    output       done
);

reg [1:0] state;
reg [23:0] out_bytes_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        out_bytes_reg <= 24'd0;
    end else begin
        case (state)
            2'b00: begin // idle
                if (in[3]) begin
                    out_bytes_reg[23:16] <= in;
                    state <= 2'b01;
                end
            end
            2'b01: begin // byte1
                out_bytes_reg[15:8] <= in;
                state <= 2'b10;
            end
            2'b10: begin // byte2
                out_bytes_reg[7:0] <= in;
                state <= 2'b11;
            end
            2'b11: begin // byte3
                state <= 2'b00;
            end
            default: state <= 2'b00;
        endcase
    end
end

always @(posedge clk) begin
    if (reset) begin
        done <= 1'b0;
    end else begin
        case (state)
            2'b11: done <= 1'b1;
            default: done <= 1'b0;
        endcase
    end
end

assign out_bytes = out_bytes_reg;

endmodule
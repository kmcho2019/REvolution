module TopModule (
    input  clk,
    input  reset,
    input  [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [23:0] out_bytes_reg;
reg [2:0] state_reg;
reg [2:0] state_next;

always @(*) begin
    case (state_reg)
        0: begin // IDLE
            if (in[3] == 1'b1) begin
                out_bytes_reg[23:16] = in;
                state_next = 1; // BYTE1
            end else begin
                state_next = 0; // IDLE
            end
        end
        1: begin // BYTE1
            out_bytes_reg[15:8] = in;
            state_next = 2; // BYTE2
        end
        2: begin // BYTE2
            out_bytes_reg[7:0] = in;
            state_next = 3; // BYTE3
        end
        3: begin // BYTE3
            state_next = 0; // IDLE
        end
        default: state_next = 0; // IDLE
    endcase
end

always @ (posedge clk) begin
    if (reset) begin
        state_reg <= 0;
    end else begin
        state_reg <= state_next;
    end
end

assign done = (state_reg == 3'b011);
assign out_bytes = out_bytes_reg;

endmodule
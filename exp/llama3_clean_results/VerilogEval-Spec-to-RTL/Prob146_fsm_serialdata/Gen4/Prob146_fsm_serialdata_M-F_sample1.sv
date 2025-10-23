module TopModule(
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg [1:0] state_reg; // 2 states: IDLE (0), DATA (1), STOP_WAIT (2)
reg [3:0] data_count_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state_reg <= 0; // IDLE
        out_byte_reg <= 8'b0;
        data_count_reg <= 4'b0000;
    end else begin
        case (state_reg)
            0: begin // IDLE
                if (in == 1'b0) begin // start bit
                    state_reg <= 1; // DATA
                    out_byte_reg <= 8'b0;
                    data_count_reg <= 4'b0001;
                end else begin
                    state_reg <= 0; // IDLE
                end
            end
            1: begin // DATA
                if (data_count_reg == 4'b1000) begin // received 8 data bits
                    state_reg <= 2; // STOP_WAIT
                end else begin
                    state_reg <= 1; // DATA
                end
                out_byte_reg <= {out_byte_reg[7:1], in};
                data_count_reg <= (data_count_reg == 4'b1000)? 4'b0000 : data_count_reg + 1'b1;
            end
            2: begin // STOP_WAIT
                if (in == 1'b1) begin // stop bit
                    state_reg <= 0; // IDLE
                end
            end
            default: begin
                state_reg <= 0; // IDLE
            end
        endcase
    end
end

assign done = (state_reg == 2 && in == 1'b1)? 1'b1 : 1'b0;
assign out_byte = (state_reg == 2 && in == 1'b1)? out_byte_reg : 8'bxxxxxxxx;

endmodule
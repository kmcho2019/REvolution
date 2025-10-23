module TopModule(
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg [2:0] state_reg; // 3 states: IDLE (0), START (1), DATA (2)
reg [2:0] data_count_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state_reg <= 0; // IDLE
        out_byte_reg <= 8'b0;
        data_count_reg <= 3'b000;
    end else begin
        case (state_reg)
            0: begin // IDLE
                if (in == 1'b0) begin // start bit
                    state_reg <= 1; // START
                    out_byte_reg <= 8'b0;
                    data_count_reg <= 3'b000;
                end else begin
                    state_reg <= 0; // IDLE
                end
            end
            1: begin // START
                state_reg <= 2; // DATA
                data_count_reg <= 3'b001;
            end
            2: begin // DATA
                if (data_count_reg == 3'b111) begin // received 8 data bits
                    state_reg <= 3; // STOP
                end else begin
                    state_reg <= 2; // DATA
                end
                out_byte_reg <= {out_byte_reg[7:1], in};
                data_count_reg <= (data_count_reg == 3'b111)? 3'b000 : data_count_reg + 1'b1;
            end
            3: begin // STOP
                if (in == 1'b1) begin // stop bit
                    state_reg <= 0; // IDLE
                end else begin
                    state_reg <= 0; // IDLE
                end
            end
            default: begin
                state_reg <= 0; // IDLE
            end
        endcase
    end
end

assign done = (state_reg == 3 && in == 1'b1)? 1'b1 : 1'b0;
assign out_byte = (state_reg == 3 && in == 1'b1)? out_byte_reg : 8'bxxxxxxxx;

endmodule
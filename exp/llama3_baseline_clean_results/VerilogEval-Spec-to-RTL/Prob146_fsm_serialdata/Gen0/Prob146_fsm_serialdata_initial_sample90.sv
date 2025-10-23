module TopModule(
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] data_byte;
reg [2:0] state;
reg [3:0] bit_count;
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        data_byte <= 8'b0;
        bit_count <= 4'b0;
        done_reg <= 1'b0;
    end else begin
        case (state)
            0: begin // idle state
                if (!in) begin
                    state <= 1;
                end else begin
                    state <= 0;
                end
            end
            1: begin // start bit detected, start collecting data bits
                data_byte <= {data_byte[6:0], in};
                bit_count <= bit_count + 1;
                if (bit_count == 4'd8) begin
                    state <= 2;
                    bit_count <= 4'b0;
                end else begin
                    state <= 1;
                end
            end
            2: begin // stop bit verification
                if (in) begin
                    state <= 0;
                    done_reg <= 1'b1;
                end else begin
                    state <= 2;
                end
            end
            default: state <= 0;
        endcase
    end
end

assign out_byte = data_byte;
assign done = done_reg;

always @(posedge clk) begin
    if (state == 2) begin
        done_reg <= 1'b0;
    end
end

endmodule
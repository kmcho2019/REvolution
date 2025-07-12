module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg done_reg;
reg [2:0] bit_count;
reg [7:0] shift_reg;

always @(posedge clk) begin
    if (reset) begin
        out_byte_reg <= 8'b0;
        done_reg <= 1'b0;
        bit_count <= 3'b0;
        shift_reg <= 8'b0;
    end else begin
        case (bit_count)
            3'b000: begin // IDLE state
                if (in == 1'b0) begin
                    shift_reg <= 8'b0;
                    bit_count <= 3'b001;
                end else begin
                    bit_count <= 3'b000;
                end
            end
            3'b001, 3'b010, 3'b011, 3'b100, 3'b101, 3'b110, 3'b111: begin // DATA state
                shift_reg <= {in, shift_reg[7:1]};
                bit_count <= bit_count + 1;
                if (bit_count == 3'b111) begin
                    bit_count <= 3'b000;
                end
            end
            default: begin
                if (in == 1'b1) begin
                    out_byte_reg <= shift_reg;
                    done_reg <= 1'b1;
                    bit_count <= 3'b000;
                end else begin
                    bit_count <= 3'b000;
                end
            end
        endcase
        if (bit_count != 3'b000) begin
            done_reg <= 1'b0;
        end
    end
end

assign out_byte = out_byte_reg;
assign done = done_reg;

endmodule
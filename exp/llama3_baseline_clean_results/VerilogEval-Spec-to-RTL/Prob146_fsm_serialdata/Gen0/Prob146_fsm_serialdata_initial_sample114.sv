module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg done_reg;
reg [2:0] state;
reg [3:0] bit_count;

always @(posedge clk) begin
    if (reset) begin
        state <= 3'b001; // IDLE state
        done_reg <= 1'b0;
        out_byte_reg <= 8'b0;
        bit_count <= 4'b0;
    end else begin
        case (state)
            3'b001: begin // IDLE state
                if (~in) begin
                    state <= 3'b010; // START state
                    bit_count <= 4'b1;
                end
            end
            3'b010: begin // START state
                out_byte_reg[0] <= in;
                if (bit_count == 4'b1000) begin
                    state <= 3'b100; // STOP state
                    done_reg <= 1'b1;
                end else begin
                    bit_count <= bit_count + 1'b1;
                    out_byte_reg[bit_count] <= in;
                end
            end
            3'b100: begin // STOP state
                if (in) begin
                    state <= 3'b001; // IDLE state
                    done_reg <= 1'b0;
                end else begin
                    state <= 3'b100; // remain in STOP state
                end
            end
            default: state <= 3'b001; // default to IDLE state
        endcase
    end
end

assign out_byte = out_byte_reg;
assign done = done_reg;

endmodule
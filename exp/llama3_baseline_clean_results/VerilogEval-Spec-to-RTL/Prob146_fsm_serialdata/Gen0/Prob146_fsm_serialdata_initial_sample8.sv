module TopModule (
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg done_reg;
reg [2:0] state;
reg [2:0] count;

always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000; // IDLE state
        count <= 3'b000;
        out_byte_reg <= 8'b0;
        done_reg <= 1'b0;
    end else begin
        case (state)
            3'b000: begin // IDLE state
                if (!in) begin
                    state <= 3'b001; // START state
                end
            end
            3'b001: begin // START state
                state <= 3'b010; // DATA state
            end
            3'b010: begin // DATA state
                out_byte_reg <= {out_byte_reg[6:0], in}; // shift left and append input bit
                if (count == 3'b111) begin
                    state <= 3'b011; // STOP state
                end else begin
                    count <= count + 1'b1;
                end
            end
            3'b011: begin // STOP state
                if (in) begin
                    done_reg <= 1'b1;
                    state <= 3'b000; // IDLE state
                    count <= 3'b000;
                end
            end
        endcase
    end
end

assign out_byte = out_byte_reg;
assign done = done_reg;

endmodule
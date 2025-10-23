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
reg [2:0] bit_count;

localparam IDLE = 3'b000;
localparam START = 3'b001;
localparam DATA = 3'b010;
localparam STOP = 3'b011;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        bit_count <= 3'b000;
        out_byte_reg <= 8'b0;
        done_reg <= 1'b0;
    end
    else begin
        case (state)
            IDLE: begin
                if (~in) begin
                    state <= START;
                    bit_count <= 3'b000;
                end
                else begin
                    state <= IDLE;
                end
            end
            START: begin
                state <= DATA;
            end
            DATA: begin
                out_byte_reg <= {out_byte_reg[6:0], in};
                bit_count <= bit_count + 1'b1;
                if (bit_count == 3'b1000) begin
                    state <= STOP;
                end
            end
            STOP: begin
                if (in) begin
                    done_reg <= 1'b1;
                    state <= IDLE;
                end
                else begin
                    out_byte_reg <= 8'b0;
                    bit_count <= 3'b000;
                    state <= IDLE;
                end
            end
        endcase
    end
end

assign out_byte = out_byte_reg;
assign done = done_reg;

endmodule
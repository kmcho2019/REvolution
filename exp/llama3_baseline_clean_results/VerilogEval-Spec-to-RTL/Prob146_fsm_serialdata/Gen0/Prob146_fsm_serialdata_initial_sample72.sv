module TopModule(
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

reg [2:0] state;
reg [7:0] out_byte_reg;
reg [2:0] bit_counter;
reg done_reg;

parameter IDLE = 3'b000;
parameter START = 3'b001;
parameter DATA = 3'b010;
parameter STOP = 3'b011;
parameter ERROR = 3'b100;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        out_byte_reg <= 8'b0;
        bit_counter <= 3'b0;
        done_reg <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (~in) begin
                    state <= START;
                    out_byte_reg <= 8'b0;
                    bit_counter <= 3'b0;
                end else begin
                    state <= IDLE;
                end
            end
            START: begin
                out_byte_reg[0] <= in;
                state <= DATA;
                bit_counter <= 3'b1;
            end
            DATA: begin
                if (bit_counter < 8) begin
                    out_byte_reg[bit_counter] <= in;
                    state <= DATA;
                    bit_counter <= bit_counter + 1;
                end else begin
                    state <= STOP;
                end
            end
            STOP: begin
                if (in) begin
                    done_reg <= 1'b1;
                    state <= IDLE;
                end else begin
                    state <= ERROR;
                end
            end
            ERROR: begin
                if (in) begin
                    state <= IDLE;
                end else begin
                    state <= ERROR;
                end
            end
        endcase
    end
end

assign out_byte = out_byte_reg;
assign done = done_reg;

endmodule
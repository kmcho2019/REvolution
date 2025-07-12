module TopModule(
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg done_reg;
reg [2:0] state_reg; // idle, start, data, stop
reg [2:0] next_state;
reg [3:0] bit_count;

parameter IDLE = 3'b000;
parameter START = 3'b001;
parameter DATA = 3'b010;
parameter STOP = 3'b011;

always @(*) begin
    case (state_reg)
        IDLE: begin
            if (in == 0) next_state = START;
            else next_state = IDLE;
        end
        START: begin
            if (bit_count == 0) next_state = DATA;
            else next_state = START;
        end
        DATA: begin
            if (bit_count == 8) next_state = STOP;
            else next_state = DATA;
        end
        STOP: begin
            if (in == 1) next_state = IDLE;
            else next_state = STOP;
        end
        default: next_state = IDLE;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state_reg <= IDLE;
        out_byte_reg <= 8'b0;
        done_reg <= 0;
        bit_count <= 0;
    end
    else begin
        case (state_reg)
            IDLE: begin
                state_reg <= next_state;
                out_byte_reg <= 8'b0;
                done_reg <= 0;
                bit_count <= 0;
            end
            START: begin
                state_reg <= next_state;
                out_byte_reg <= 8'b0;
                done_reg <= 0;
                bit_count <= 1;
            end
            DATA: begin
                state_reg <= next_state;
                out_byte_reg <= {out_byte_reg[6:0], in};
                done_reg <= 0;
                bit_count <= bit_count + 1;
            end
            STOP: begin
                state_reg <= next_state;
                done_reg <= 1;
            end
            default: state_reg <= IDLE;
        endcase
    end
end

assign out_byte = out_byte_reg;
assign done = done_reg;

endmodule
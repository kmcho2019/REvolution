module TopModule (
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg [2:0] state_reg;  // 3 states: IDLE (0), START (1), DATA (2), STOP (3), INVALID_STOP (4)
reg [2:0] state_next;
reg [7:0] out_byte_next;
reg done_reg;
reg done_next;
reg [3:0] bit_counter_reg;  // Counter for the 8 data bits
reg [3:0] bit_counter_next;

// Encoding for states
parameter IDLE = 3'b000;
parameter START = 3'b001;
parameter DATA = 3'b010;
parameter STOP = 3'b011;
parameter INVALID_STOP = 3'b100;

// Next state logic
always @(*) begin
    case (state_reg)
        IDLE: begin
            if (in == 0) begin
                state_next = START;
                out_byte_next = 8'b0;
                bit_counter_next = 4'b1;
                done_next = 1'b0;
            end else begin
                state_next = IDLE;
                out_byte_next = out_byte_reg;
                bit_counter_next = bit_counter_reg;
                done_next = 1'b0;
            end
        end
        START: begin
            state_next = DATA;
            out_byte_next = {out_byte_reg[7:1], in};
            bit_counter_next = bit_counter_reg + 1'b1;
            done_next = 1'b0;
        end
        DATA: begin
            if (bit_counter_reg < 4'd8) begin
                state_next = DATA;
                out_byte_next = {out_byte_reg[7:1], in};
                bit_counter_next = bit_counter_reg + 1'b1;
                done_next = 1'b0;
            end else begin
                state_next = STOP;
                out_byte_next = out_byte_reg;
                bit_counter_next = bit_counter_reg;
                done_next = 1'b0;
            end
        end
        STOP: begin
            if (in == 1) begin
                state_next = IDLE;
                out_byte_next = out_byte_reg;
                bit_counter_next = 4'b0;
                done_next = 1'b1;
            end else begin
                state_next = INVALID_STOP;
                out_byte_next = out_byte_reg;
                bit_counter_next = bit_counter_reg;
                done_next = 1'b0;
            end
        end
        INVALID_STOP: begin
            if (in == 1) begin
                state_next = IDLE;
                out_byte_next = 8'b0;
                bit_counter_next = 4'b0;
                done_next = 1'b1;
            end else begin
                state_next = INVALID_STOP;
                out_byte_next = out_byte_reg;
                bit_counter_next = bit_counter_reg;
                done_next = 1'b0;
            end
        end
        default: begin
            state_next = IDLE;
            out_byte_next = 8'b0;
            bit_counter_next = 4'b0;
            done_next = 1'b0;
        end
    endcase
end

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
        state_reg <= IDLE;
        out_byte_reg <= 8'b0;
        done_reg <= 1'b0;
        bit_counter_reg <= 4'b0;
    end else begin
        state_reg <= state_next;
        out_byte_reg <= out_byte_next;
        done_reg <= done_next;
        bit_counter_reg <= bit_counter_next;
    end
end

assign out_byte = out_byte_reg;
assign done = done_reg;

endmodule
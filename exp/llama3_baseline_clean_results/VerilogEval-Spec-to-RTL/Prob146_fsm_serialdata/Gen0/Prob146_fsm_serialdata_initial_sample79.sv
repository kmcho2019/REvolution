module TopModule(
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg done_reg;
reg [2:0] state_reg; // 3 states: IDLE (0), START_BIT (1), DATA_BITS (2), STOP_BIT (3), DONE (4)
reg [3:0] bit_counter; // count the data bits
reg [7:0] shift_reg; // shift register for the data bits

localparam IDLE = 3'b000;
localparam START_BIT = 3'b001;
localparam DATA_BITS = 3'b010;
localparam STOP_BIT = 3'b011;
localparam DONE = 3'b100;

always @(posedge clk) begin
    if (reset) begin
        state_reg <= IDLE;
        bit_counter <= 0;
        out_byte_reg <= 0;
        shift_reg <= 0;
        done_reg <= 0;
    end else begin
        case (state_reg)
            IDLE: begin
                if (~in) begin
                    state_reg <= START_BIT;
                end else begin
                    state_reg <= IDLE;
                end
            end
            START_BIT: begin
                state_reg <= DATA_BITS;
            end
            DATA_BITS: begin
                shift_reg[7:1] <= shift_reg[6:0];
                shift_reg[0] <= in;
                bit_counter <= bit_counter + 1;
                if (bit_counter == 4'd7) begin
                    state_reg <= STOP_BIT;
                end
            end
            STOP_BIT: begin
                if (in) begin
                    state_reg <= DONE;
                end
            end
            DONE: begin
                out_byte_reg <= shift_reg;
                done_reg <= 1;
                state_reg <= IDLE;
            end
            default: state_reg <= IDLE;
        endcase
        if (state_reg!= DONE) begin
            done_reg <= 0;
        end
        if (state_reg == DONE) begin
            bit_counter <= 0;
        end
    end
end

assign out_byte = out_byte_reg;
assign done = done_reg;

endmodule
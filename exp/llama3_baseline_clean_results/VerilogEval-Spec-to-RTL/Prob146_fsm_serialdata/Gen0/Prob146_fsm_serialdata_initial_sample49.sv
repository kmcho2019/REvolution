module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg done_reg;

reg [2:0] state_reg;
localparam IDLE = 3'b001;
localparam START_BIT = 3'b010;
localparam DATA_BITS = 3'b011;
localparam STOP_BIT = 3'b100;

reg [2:0] state_next;
reg [7:0] out_byte_next;
reg done_next;
reg [2:0] bit_counter;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state_reg <= IDLE;
        out_byte_reg <= 8'b0;
        done_reg <= 1'b0;
        bit_counter <= 3'b000;
    end else begin
        state_reg <= state_next;
        out_byte_reg <= out_byte_next;
        done_reg <= done_next;
    end
end

always @(*) begin
    state_next = state_reg;
    out_byte_next = out_byte_reg;
    done_next = 1'b0;
    case(state_reg)
        IDLE: begin
            if(!in) begin
                state_next = START_BIT;
            end
        end
        START_BIT: begin
            state_next = DATA_BITS;
            bit_counter = 3'b000;
            out_byte_next = 8'b0;
        end
        DATA_BITS: begin
            out_byte_next = {out_byte_reg[6:0], in};
            if(bit_counter == 3'b111) begin
                state_next = STOP_BIT;
            end else begin
                bit_counter = bit_counter + 1'b1;
            end
        end
        STOP_BIT: begin
            if(in) begin
                done_next = 1'b1;
                state_next = IDLE;
            end
        end
        default: begin
            state_next = IDLE;
        end
    endcase
end

assign out_byte = out_byte_reg;
assign done = done_reg;

endmodule
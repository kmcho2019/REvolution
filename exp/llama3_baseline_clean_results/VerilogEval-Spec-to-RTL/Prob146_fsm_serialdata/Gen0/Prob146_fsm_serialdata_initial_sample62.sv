module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] data_reg;
reg [2:0] state_reg;
reg [2:0] next_state;
reg [7:0] counter;
reg [7:0] out_byte_reg;
reg done_reg;

parameter IDLE = 3'b000;
parameter START_BIT = 3'b001;
parameter DATA_BITS = 3'b010;
parameter STOP_BIT = 3'b011;

always @(*) begin
    case(state_reg)
        IDLE: begin
            if (~in) begin
                next_state = START_BIT;
            end else begin
                next_state = IDLE;
            end
        end
        START_BIT: begin
            if (in) begin
                next_state = IDLE;
            end else begin
                next_state = DATA_BITS;
                counter = 8'd1;
                data_reg = 8'd0;
            end
        end
        DATA_BITS: begin
            if (counter == 8'd8) begin
                next_state = STOP_BIT;
            end else begin
                next_state = DATA_BITS;
                counter = counter + 1'd1;
                data_reg = {data_reg[6:0], in};
            end
        end
        STOP_BIT: begin
            if (in) begin
                next_state = IDLE;
                done_reg = 1'b1;
                out_byte_reg = data_reg;
            end else begin
                next_state = IDLE;
                done_reg = 1'b0;
            end
        end
        default: next_state = IDLE;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state_reg <= IDLE;
        done_reg <= 1'b0;
        out_byte_reg <= 8'd0;
        counter <= 8'd0;
        data_reg <= 8'd0;
    end else begin
        state_reg <= next_state;
        done <= done_reg;
        out_byte <= out_byte_reg;
    end
end

assign out_byte = out_byte_reg;
assign done = done_reg;

endmodule
module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] data_reg;
reg [2:0] state_reg;
reg [2:0] state_next;
reg [7:0] counter;
reg done_reg;

parameter IDLE = 3'b000;
parameter START = 3'b001;
parameter DATA = 3'b010;
parameter STOP = 3'b011;
parameter ERROR = 3'b100;

always @(posedge clk) begin
    if(reset) begin
        state_reg <= IDLE;
        counter <= 8'b0;
        data_reg <= 8'b0;
        done_reg <= 1'b0;
    end else begin
        state_reg <= state_next;
        counter <= (state_reg == DATA) ? counter + 1 : (state_reg == STOP) ? 8'b0 : counter;
        data_reg <= (state_reg == DATA) ? {data_reg[6:0], in} : data_reg;
        done_reg <= (state_reg == STOP && in == 1) ? 1'b1 : 1'b0;
    end
end

always @(*) begin
    case(state_reg)
        IDLE: state_next = (in == 1'b0) ? START : IDLE;
        START: state_next = DATA;
        DATA: state_next = (counter == 8) ? STOP : DATA;
        STOP: state_next = (in == 1'b1) ? IDLE : ERROR;
        ERROR: state_next = (in == 1'b1) ? IDLE : ERROR;
    endcase
end

assign out_byte = data_reg;
assign done = done_reg;

endmodule
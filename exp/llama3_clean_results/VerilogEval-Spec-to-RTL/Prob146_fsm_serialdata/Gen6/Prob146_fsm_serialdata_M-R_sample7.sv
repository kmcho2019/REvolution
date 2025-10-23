module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output done
);

reg [7:0] shift_reg;
reg [1:0] state_reg;
reg [3:0] counter_reg;

parameter IDLE = 2'b00;
parameter DATA = 2'b01;
parameter STOP = 2'b10;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state_reg <= IDLE;
        counter_reg <= 0;
        shift_reg <= 8'b0;
    end
    else begin
        case(state_reg)
            IDLE: begin
                if (!in) begin
                    state_reg <= DATA;
                    counter_reg <= 1;
                    shift_reg <= {7'b0, in};
                end
                else begin
                    state_reg <= IDLE;
                end
            end
            DATA: begin
                if (counter_reg < 8) begin
                    state_reg <= DATA;
                    counter_reg <= counter_reg + 1;
                    shift_reg <= {shift_reg[6:0], in};
                end
                else begin
                    state_reg <= STOP;
                    counter_reg <= 0;
                end
            end
            STOP: begin
                if (in) begin
                    state_reg <= IDLE;
                end
                else begin
                    state_reg <= STOP;
                end
            end
        endcase
    end
end

assign done = (state_reg == STOP) && in;
assign out_byte = (done) ? shift_reg : 8'b0;

endmodule
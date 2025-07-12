module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output reg done
);

reg [2:0] counter;
reg [7:0] data_reg;
reg [1:0] state_reg;

parameter IDLE = 2'b00;
parameter START = 2'b01;
parameter DATA = 2'b10;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state_reg <= IDLE;
        counter <= 3'b000;
        data_reg <= 8'b0;
        done <= 0;
    end
    else begin
        case(state_reg)
            IDLE: begin
                if (!in) begin
                    state_reg <= START;
                end
            end
            START: begin
                state_reg <= DATA;
            end
            DATA: begin
                data_reg <= {data_reg[6:0], in};
                counter <= counter + 1;
                if (counter == 3'd8) begin
                    state_reg <= DATA + 1;
                end
            end
            default: begin
                if (in) begin
                    done <= 1;
                    out_byte <= data_reg;
                    state_reg <= IDLE;
                end
                else begin
                    state_reg <= IDLE;
                end
            end
        endcase
    end
end

always @(posedge clk) begin
    if (state_reg == IDLE) begin
        done <= 0;
    end
end

endmodule
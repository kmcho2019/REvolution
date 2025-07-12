module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

reg [3:0] counter;
reg [7:0] data_reg;
reg [1:0] state_reg;

parameter IDLE = 2'b00;
parameter START = 2'b01;
parameter DATA = 2'b10;
parameter STOP = 2'b11;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state_reg <= IDLE;
        counter <= 4'b0000;
        data_reg <= 8'b0;
        done <= 0;
        out_byte <= 8'b0;
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
                counter <= 4'b0001;
                data_reg <= {7'b0, in};
            end
            DATA: begin
                data_reg <= {data_reg[6:0], in};
                counter <= counter + 1;
                if (counter == 4'd8) begin
                    state_reg <= STOP;
                end
            end
            STOP: begin
                if (in) begin
                    out_byte <= data_reg;
                    done <= 1;
                end
                state_reg <= IDLE;
                done <= 0;
            end
        endcase
    end
end

endmodule
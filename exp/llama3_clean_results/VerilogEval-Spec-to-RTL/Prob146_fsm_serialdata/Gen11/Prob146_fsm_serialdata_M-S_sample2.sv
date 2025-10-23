module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

reg [2:0] counter;
reg [7:0] data_reg;
reg [1:0] state_reg;

parameter IDLE = 2'b00;
parameter DATA = 2'b01;
parameter STOP = 2'b10;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state_reg <= IDLE;
        counter <= 3'b000;
        data_reg <= 8'b0;
        done <= 0;
        out_byte <= 8'b0;
    end
    else begin
        case(state_reg)
            IDLE: begin
                if (!in) begin
                    state_reg <= DATA;
                    counter <= 3'b000;
                    data_reg <= 8'b0;
                end
            end
            DATA: begin
                if (counter == 3'd7) begin
                    data_reg[7] <= in;
                    state_reg <= STOP;
                end
                else begin
                    data_reg[counter] <= in;
                    counter <= counter + 1;
                end
            end
            STOP: begin
                if (in) begin
                    out_byte <= {data_reg[6:0], data_reg[7]};
                    done <= 1;
                end
                else begin
                    out_byte <= 8'b0;
                    done <= 0;
                end
                if (in) begin
                    state_reg <= IDLE;
                    done <= 0;
                end
                else begin
                    state_reg <= STOP;
                end
            end
        endcase
    end
end

endmodule
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
parameter START = 2'b01;
parameter DATA = 2'b10;

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
                    state_reg <= START;
                end
            end
            START: begin
                state_reg <= DATA;
                counter <= 3'b001;
                data_reg <= 8'b0;
            end
            DATA: begin
                data_reg <= {data_reg[6:0], in};
                counter <= counter + 1;
                if (counter == 3'b100) begin
                    if (in) begin // Stop bit verification
                        state_reg <= IDLE;
                        out_byte <= data_reg;
                        done <= 1;
                    end
                    else begin // Invalid stop bit, wait for stop bit
                        state_reg <= DATA;
                        counter <= 3'b100;
                    end
                end
            end
        endcase
        if (state_reg == IDLE && done) begin
            done <= 0;
        end
    end
end

endmodule
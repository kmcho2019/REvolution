module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

reg [2:0] counter;
reg [7:0] shift_reg;
reg [1:0] state_reg;

parameter IDLE = 2'b00;
parameter DATA = 2'b01;
parameter STOP = 2'b10;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state_reg <= IDLE;
        counter <= 3'b000;
        shift_reg <= 8'b0;
        done <= 0;
        out_byte <= 8'b0;
    end
    else begin
        case(state_reg)
            IDLE: begin
                if (!in) begin
                    state_reg <= DATA;
                    counter <= 3'b001;
                    shift_reg <= 8'b0;
                end
            end
            DATA: begin
                shift_reg <= {shift_reg[6:0], in};
                counter <= counter + 1;
                if (counter == 3'd8) begin
                    state_reg <= STOP;
                end
            end
            STOP: begin
                if (in) begin
                    out_byte <= shift_reg;
                    done <= 1;
                    state_reg <= IDLE;
                end
                else begin
                    state_reg <= STOP;
                end
            end
        endcase
    end
end

endmodule
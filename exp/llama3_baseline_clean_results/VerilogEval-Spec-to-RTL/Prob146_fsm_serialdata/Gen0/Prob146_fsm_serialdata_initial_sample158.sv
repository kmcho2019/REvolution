module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg done_reg;
reg [2:0] state_reg; // 0: idle, 1: start, 2: data, 3: stop
reg [3:0] data_count_reg; // count the number of data bits received
reg [7:0] data_reg; // register to store the received data bits

localparam IDLE = 3'b000;
localparam START = 3'b001;
localparam DATA = 3'b010;
localparam STOP = 3'b011;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state_reg <= IDLE;
        data_count_reg <= 0;
        data_reg <= 0;
        out_byte_reg <= 0;
        done_reg <= 0;
    end else begin
        case (state_reg)
            IDLE: begin
                if (!in) begin // start bit detected
                    state_reg <= START;
                    data_count_reg <= 0;
                    data_reg <= 0;
                end
            end
            START: begin
                state_reg <= DATA;
            end
            DATA: begin
                data_reg[data_count_reg] <= in;
                data_count_reg <= data_count_reg + 1;
                if (data_count_reg == 8) begin
                    state_reg <= STOP;
                end
            end
            STOP: begin
                if (in) begin // stop bit detected
                    out_byte_reg <= data_reg;
                    done_reg <= 1;
                    state_reg <= IDLE;
                end
            end
        endcase
        done_reg <= (state_reg == STOP && in) ? 1 : 0;
    end
end

assign out_byte = out_byte_reg;
assign done = done_reg;

endmodule
module TopModule(
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

reg [3:0] delay; // delay register
reg [11:0] counter; // counter to count total clock cycles
reg [3:0] current_count; // current count to be output
reg counting_reg; // register to hold counting output
reg done_reg; // register to hold done output
reg [3:0] data_reg; // register to hold the last 4 bits of data
reg [2:0] state; // state register
parameter IDLE = 3'b001, SHIFT = 3'b010, COUNT = 3'b011, DONE = 3'b100;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        done_reg <= 0;
        counting_reg <= 0;
        counter <= 0;
        current_count <= 0;
        delay <= 0;
        data_reg <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data_reg == 4'b1101) begin
                    state <= SHIFT;
                    data_reg <= 0;
                end else begin
                    data_reg <= {data_reg[2:0], data};
                end
            end
            SHIFT: begin
                data_reg <= {data_reg[2:0], data};
                if (data_reg[3]) begin
                    delay <= data_reg;
                    state <= COUNT;
                    counter <= 0;
                    current_count <= delay;
                    counting_reg <= 1;
                end
            end
            COUNT: begin
                counter <= counter + 1;
                if (counter == (delay + 1) * 1000 - 1) begin
                    state <= DONE;
                    counting_reg <= 0;
                    done_reg <= 1;
                end else if (counter % 1000 == 999) begin
                    current_count <= current_count - 1;
                end
            end
            DONE: begin
                if (ack) begin
                    state <= IDLE;
                    done_reg <= 0;
                end
            end
        endcase
    end
end

assign count = state == COUNT ? current_count : 4'bxxxx;
assign counting = counting_reg;
assign done = done_reg;

endmodule
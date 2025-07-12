module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

reg [2:0] state;
reg [3:0] seq_reg;
reg [3:0] delay_reg;
reg [19:0] counter;
reg [3:0] remaining_time;
reg [1:0] shift_count;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0;
        seq_reg <= 0;
        delay_reg <= 0;
        counter <= 0;
        remaining_time <= 0;
        shift_count <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                seq_reg <= {seq_reg[2:0], data};
                if (seq_reg == 4'b1101) begin
                    state <= 1;
                    shift_count <= 0;
                end
            end
            1: begin // SHIFT
                delay_reg <= {data, delay_reg[3:1]};
                shift_count <= shift_count + 1;
                if (shift_count == 4) begin
                    state <= 2;
                    counter <= (delay_reg + 1) * 1000 - 1;
                    remaining_time <= delay_reg;
                end
            end
            2: begin // COUNT
                if (counter > 0) begin
                    counter <= counter - 1;
                end else begin
                    state <= 3;
                end
                if (counter % 1000 == 0 && counter > 0) begin
                    remaining_time <= remaining_time - 1;
                end
            end
            3: begin // DONE
                if (ack == 1'b1) begin
                    state <= 0;
                end
            end
        endcase
    end
end

assign count = remaining_time;
assign counting = (state == 2);
assign done = (state == 3);

endmodule
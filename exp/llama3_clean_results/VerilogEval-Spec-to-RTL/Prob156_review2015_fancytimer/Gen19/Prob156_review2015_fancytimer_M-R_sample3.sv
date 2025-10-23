module TopModule(
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

reg [1:0] state;
reg [3:0] seq_reg;
reg [3:0] delay_reg;
reg [19:0] counter;
reg [3:0] remaining_time;
reg [1:0] bit_counter;

always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 2'b00; // IDLE
        seq_reg <= 0;
        delay_reg <= 0;
        counter <= 0;
        remaining_time <= 0;
        bit_counter <= 0;
    end else begin
        case (state)
            2'b00: begin // IDLE
                seq_reg <= {seq_reg[2:0], data};
                if (seq_reg == 4'b1101) begin
                    state <= 2'b01; // SHIFT
                end
            end
            2'b01: begin // SHIFT
                delay_reg <= {data, delay_reg[3:1]};
                bit_counter <= bit_counter + 1;
                if (bit_counter == 4) begin
                    counter <= (delay_reg + 1) * 1000 - 1;
                    remaining_time <= delay_reg;
                    state <= 2'b10; // COUNT
                end
            end
            2'b10: begin // COUNT
                counter <= counter - 1;
                if (counter % 1000 == 0 && counter != 0) begin
                    remaining_time <= remaining_time - 1;
                end
                if (counter == 0) begin
                    state <= 2'b11; // DONE
                end
            end
            2'b11: begin // DONE
                if (ack == 1'b1) begin
                    state <= 2'b00; // IDLE
                end
            end
        endcase
    end
end

assign count = (state == 2'b10) ? remaining_time : 4'b0;
assign counting = (state == 2'b10);
assign done = (state == 2'b11);

endmodule
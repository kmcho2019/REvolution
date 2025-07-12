module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

reg [1:0] state;
reg [3:0] delay;
reg [19:0] counter;
reg [3:0] remaining_time;
reg [3:0] seq_reg;
reg [1:0] shift_count;

// State machine
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 2'b00; // IDLE
        seq_reg <= 4'b0000;
        delay <= 4'b0000;
        counter <= 20'b0;
        remaining_time <= 4'b0000;
        counting <= 1'b0;
        done <= 1'b0;
        shift_count <= 2'b00;
    end else begin
        case (state)
            2'b00: begin // IDLE
                if (seq_reg == 4'b1101) begin
                    state <= 2'b01; // SHIFT
                end else begin
                    state <= 2'b00;
                    seq_reg <= {seq_reg[2:0], data};
                end
            end
            2'b01: begin // SHIFT
                if (shift_count == 2'b11) begin
                    state <= 2'b10; // COUNT
                    remaining_time <= delay + 1;
                end else begin
                    state <= 2'b01;
                    delay <= {data, delay[3:1]};
                    shift_count <= shift_count + 1;
                end
            end
            2'b10: begin // COUNT
                if (counter == (delay + 1) * 1000 - 1) begin
                    state <= 2'b11; // DONE
                end else begin
                    state <= 2'b10;
                    counter <= counter + 1;
                    if (counter % 1000 == 0) begin
                        remaining_time <= remaining_time - 1;
                    end
                end
            end
            2'b11: begin // DONE
                if (ack == 1'b1) begin
                    state <= 2'b00; // IDLE
                end else begin
                    state <= 2'b11;
                end
            end
        endcase
    end
end

// Output logic
assign counting = (state == 2'b10) ? 1'b1 : 1'b0;
assign done = (state == 2'b11) ? 1'b1 : 1'b0;
assign count = (state == 2'b10) ? remaining_time : 4'bxxxx;

endmodule
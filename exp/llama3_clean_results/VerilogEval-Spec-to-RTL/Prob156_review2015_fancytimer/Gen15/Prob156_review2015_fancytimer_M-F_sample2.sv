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
reg [9:0] cycle_counter;
reg [1:0] bit_counter;

// State machine
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0;
        seq_reg <= 0;
        delay_reg <= 0;
        counter <= 0;
        remaining_time <= 0;
        cycle_counter <= 0;
        bit_counter <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                seq_reg <= {seq_reg[2:0], data};
                if (seq_reg == 4'b1101) begin
                    state <= 1;
                end
            end
            1: begin // SHIFT
                if (bit_counter < 4) begin
                    delay_reg <= {data, delay_reg[3:1]};
                    bit_counter <= bit_counter + 1;
                end
                if (bit_counter == 4) begin
                    state <= 2;
                    counter <= (delay_reg + 1) * 1000 - 1;
                    remaining_time <= delay_reg;
                    cycle_counter <= 0;
                    counting <= 1;
                end
                if (ack == 1'b1) begin
                    state <= 0;
                end
            end
            2: begin // COUNT
                counter <= counter - 1;
                cycle_counter <= cycle_counter + 1;
                if (cycle_counter == 1000) begin
                    remaining_time <= remaining_time - 1;
                    cycle_counter <= 0;
                end
                if (counter == 0) begin
                    state <= 3;
                    counting <= 0;
                end
                if (ack == 1'b1) begin
                    state <= 0;
                end
            end
            3: begin // DONE
                done <= 1;
                if (ack == 1'b1) begin
                    state <= 0;
                    done <= 0;
                end
            end
        endcase
    end
end

// Assign outputs
assign count = (state == 2) ? remaining_time : 4'bxxxx;

endmodule
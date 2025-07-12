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

// State machine
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0;
        seq_reg <= 0;
        delay_reg <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                seq_reg <= {seq_reg[2:0], data};
                if (seq_reg == 4'b1101) begin
                    state <= 1;
                end
            end
            1: begin // SHIFT
                delay_reg <= {data, delay_reg[3:1]};
                if (delay_reg[3] == 1'b1) begin
                    state <= 2;
                end
            end
            2: begin // COUNT
                if (counter == 0) begin
                    state <= 3;
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

// Counter
always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 0;
        remaining_time <= 0;
        cycle_counter <= 0;
    end else begin
        case (state)
            1: begin // SHIFT
                if (delay_reg[3] == 1'b1) begin
                    counter <= (delay_reg + 1) * 1000 - 1;
                    remaining_time <= delay_reg;
                    cycle_counter <= 0;
                end
            end
            2: begin // COUNT
                counter <= counter - 1;
                cycle_counter <= cycle_counter + 1;
                if (cycle_counter == 1000) begin
                    remaining_time <= remaining_time - 1;
                    cycle_counter <= 0;
                end
            end
        endcase
    end
end

// Assign outputs
assign count = (state == 2) ? remaining_time : 4'bxxxx;
assign counting = (state == 2);
assign done = (state == 3);

endmodule
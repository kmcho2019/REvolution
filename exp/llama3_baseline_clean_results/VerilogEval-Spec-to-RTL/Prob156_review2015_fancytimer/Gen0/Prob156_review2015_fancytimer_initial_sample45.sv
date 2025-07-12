module TopModule(
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

reg [3:0] state;
reg [3:0] delay;
reg [3:0] current_count;
reg [9:0] total_count;
reg counting_reg;
reg done_reg;
reg [3:0] shift_reg;

always @ (posedge clk) begin
    if (reset) begin
        state <= 0;
        delay <= 0;
        current_count <= 0;
        total_count <= 0;
        counting_reg <= 0;
        done_reg <= 0;
        shift_reg <= 0;
    end else begin
        case (state)
            0: begin // Search for 1101 pattern
                if (data == 1) begin
                    shift_reg <= {1, shift_reg[3:1]};
                    if (shift_reg == 4'b1101) begin
                        state <= 1;
                    end
                end else begin
                    shift_reg <= {0, shift_reg[3:1]};
                end
            end
            1: begin // Shift in delay value
                if (data == 1) begin
                    delay[3] <= 1;
                end else begin
                    delay[3] <= 0;
                end
                state <= 2;
            end
            2: begin // Shift in next 3 bits of delay value
                if (data == 1) begin
                    delay[2] <= 1;
                end else begin
                    delay[2] <= 0;
                end
                state <= 3;
            end
            3: begin // Shift in next 2 bits of delay value
                if (data == 1) begin
                    delay[1] <= 1;
                end else begin
                    delay[1] <= 0;
                end
                state <= 4;
            end
            4: begin // Shift in last bit of delay value
                if (data == 1) begin
                    delay[0] <= 1;
                end else begin
                    delay[0] <= 0;
                end
                total_count <= (delay + 1) * 1000 - 1;
                current_count <= delay;
                counting_reg <= 1;
                state <= 5;
            end
            5: begin // Count down
                if (total_count == 0) begin
                    counting_reg <= 0;
                    done_reg <= 1;
                    state <= 6;
                end else begin
                    total_count <= total_count - 1;
                    if (total_count % 1000 == 0) begin
                        current_count <= current_count - 1;
                    end
                end
            end
            6: begin // Wait for ack
                if (ack) begin
                    state <= 0;
                    done_reg <= 0;
                end
            end
        endcase
    end
end

assign count = current_count;
assign counting = counting_reg;
assign done = done_reg;

endmodule
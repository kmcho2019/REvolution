module TopModule(
    input  clk,
    input  reset,
    input  data,
    output [3:0] count,
    output counting,
    output done,
    input  ack
);

reg [3:0] count_reg;
reg counting_reg;
reg done_reg;
reg [3:0] delay_reg;
reg [9:0] counter_reg;
reg [3:0] pattern_reg;
reg [3:0] shift_counter;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        count_reg <= 4'd0;
        counting_reg <= 1'b0;
        done_reg <= 1'b0;
        delay_reg <= 4'd0;
        counter_reg <= 10'd0;
        pattern_reg <= 4'd0;
        shift_counter <= 4'd0;
    end else begin
        case (state)
            IDLE: begin
                if (data == 1'b1 && pattern_reg == 4'b0110) begin
                    pattern_reg <= 4'b1101;
                    state <= SHIFT;
                end else if (data == 1'b1 && pattern_reg == 4'b1100) begin
                    pattern_reg <= 4'b1100;
                end else if (data == 1'b1 && pattern_reg == 4'b1010) begin
                    pattern_reg <= 4'b1010;
                end else if (data == 1'b1 && pattern_reg == 4'b1000) begin
                    pattern_reg <= 4'b1000;
                end else if (data == 1'b1) begin
                    pattern_reg <= 4'b1000;
                end else if (data == 1'b0 && pattern_reg == 4'b0110) begin
                    pattern_reg <= 4'b0011;
                end else if (data == 1'b0 && pattern_reg == 4'b1100) begin
                    pattern_reg <= 4'b0110;
                end else if (data == 1'b0 && pattern_reg == 4'b1010) begin
                    pattern_reg <= 4'b0101;
                end else if (data == 1'b0 && pattern_reg == 4'b1000) begin
                    pattern_reg <= 4'b0100;
                end else if (data == 1'b0 && pattern_reg == 4'b0100) begin
                    pattern_reg <= 4'b0010;
                end else if (data == 1'b0 && pattern_reg == 4'b0101) begin
                    pattern_reg <= 4'b0010;
                end else if (data == 1'b0 && pattern_reg == 4'b0010) begin
                    pattern_reg <= 4'b0001;
                end else if (data == 1'b0 && pattern_reg == 4'b0011) begin
                    pattern_reg <= 4'b0001;
                end else if (data == 1'b0 && pattern_reg == 4'b0001) begin
                    pattern_reg <= 4'b0000;
                end else if (data == 1'b0) begin
                    pattern_reg <= 4'b0000;
                end else begin
                    pattern_reg <= 4'b0000;
                end
            end
            SHIFT: begin
                if (shift_counter == 4'd0) begin
                    delay_reg[3] <= data;
                    shift_counter <= shift_counter + 1'b1;
                end else if (shift_counter == 4'd1) begin
                    delay_reg[2] <= data;
                    shift_counter <= shift_counter + 1'b1;
                end else if (shift_counter == 4'd2) begin
                    delay_reg[1] <= data;
                    shift_counter <= shift_counter + 1'b1;
                end else if (shift_counter == 4'd3) begin
                    delay_reg[0] <= data;
                    shift_counter <= 4'd0;
                    state <= COUNT;
                    counting_reg <= 1'b1;
                    counter_reg <= (delay_reg + 1'b1) * 10'd1000 - 10'd1;
                end
            end
            COUNT: begin
                if (counter_reg == 10'd0) begin
                    if (delay_reg == 4'd0) begin
                        state <= DONE;
                        done_reg <= 1'b1;
                        counting_reg <= 1'b0;
                    end else begin
                        delay_reg <= delay_reg - 1'b1;
                        counter_reg <= 10'd999;
                    end
                end else begin
                    counter_reg <= counter_reg - 1'b1;
                end
            end
            DONE: begin
                if (ack == 1'b1) begin
                    state <= IDLE;
                    done_reg <= 1'b0;
                end
            end
        endcase
    end
end

always @(posedge clk) begin
    count <= delay_reg;
end

reg [1:0] state;
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 2'd0; // IDLE
    end else begin
        case (state)
            2'd0: begin // IDLE
                if (pattern_reg == 4'b1101) begin
                    state <= 2'd1; // SHIFT
                end
            end
            2'd1: begin // SHIFT
                if (shift_counter == 4'd4) begin
                    state <= 2'd2; // COUNT
                end
            end
            2'd2: begin // COUNT
                if (counter_reg == 10'd0 && delay_reg == 4'd0) begin
                    state <= 2'd3; // DONE
                end
            end
            2'd3: begin // DONE
                if (ack == 1'b1) begin
                    state <= 2'd0; // IDLE
                end
            end
        endcase
    end
end

endmodule
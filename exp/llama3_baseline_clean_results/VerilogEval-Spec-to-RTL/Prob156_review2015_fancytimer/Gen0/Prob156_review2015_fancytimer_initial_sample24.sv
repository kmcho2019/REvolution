module TopModule(
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

reg [3:0] count_reg;
reg counting_reg;
reg done_reg;
reg [3:0] delay_reg;
reg [3:0] counter_reg;
reg [9:0] cycle_counter;

enum logic [2:0] {Idle, PatternDetected, Counting, Done} state, next_state;

always_comb begin
    case (state)
        Idle: begin
            if (data == 1) begin
                next_state = state == Idle ? Idle : (data == 1) ? state + 1 : Idle;
            end else begin
                next_state = state;
            end
        end
        PatternDetected: begin
            if (data == 0) begin
                next_state = state + 1;
            end else begin
                next_state = state;
            end
        end
        Counting: begin
            if (cycle_counter == 1000) begin
                next_state = (count_reg == 0) ? Done : Counting;
            end else begin
                next_state = Counting;
            end
        end
        Done: begin
            if (ack == 1) begin
                next_state = Idle;
            end else begin
                next_state = Done;
            end
        end
        default: next_state = Idle;
    endcase
end

always_ff @(posedge clk) begin
    if (reset) begin
        state <= Idle;
        count_reg <= 4'b0;
        counting_reg <= 0;
        done_reg <= 0;
        delay_reg <= 4'b0;
        counter_reg <= 4'b0;
        cycle_counter <= 10'b0;
    end else begin
        state <= next_state;
        case (state)
            Idle: begin
                if (data == 1) begin
                    count_reg <= 4'b1101;
                    if (count_reg == 4'b1101) begin
                        state <= PatternDetected;
                        counter_reg <= 4'b0;
                    end
                end
            end
            PatternDetected: begin
                delay_reg <= {data, delay_reg[3:1]};
                counter_reg <= counter_reg + 1;
                if (counter_reg == 4) begin
                    count_reg <= delay_reg;
                    counting_reg <= 1;
                    cycle_counter <= 10'b0;
                end
            end
            Counting: begin
                cycle_counter <= cycle_counter + 1;
                if (cycle_counter == 1000) begin
                    count_reg <= count_reg - 1;
                    cycle_counter <= 10'b0;
                end
                if (count_reg == 0) begin
                    counting_reg <= 0;
                    done_reg <= 1;
                end
            end
            Done: begin
                done_reg <= 1;
            end
            default: ;
        endcase
    end
end

assign count = (state == Counting) ? count_reg : 4'bxxxx;
assign counting = counting_reg;
assign done = done_reg;

endmodule
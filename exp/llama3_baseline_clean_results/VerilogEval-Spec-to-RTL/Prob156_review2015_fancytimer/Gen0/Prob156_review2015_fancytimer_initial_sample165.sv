module TopModule(
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

reg [3:0] delay;
reg [3:0] current_count;
reg [9:0] cycle_count;
reg [3:0] pattern;
reg [3:0] shifted_data;
reg counting_reg;
reg done_reg;

enum logic [2:0] {
    IDLE,
    SHIFT,
    COUNT,
    DONE
} state, next_state;

always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        counting_reg <= 0;
        done_reg <= 0;
        current_count <= 0;
        cycle_count <= 0;
        pattern <= 0;
        shifted_data <= 0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (pattern == 4'b1101) begin
                    pattern <= 0;
                    next_state <= SHIFT;
                end else if (data == 1'b1) begin
                    pattern <= {pattern[2:0], 1'b1};
                end else if (data == 1'b0) begin
                    pattern <= {pattern[2:0], 1'b0};
                end else begin
                    next_state <= IDLE;
                end
            end
            SHIFT: begin
                shifted_data <= {shifted_data[2:0], data};
                if (cycle_count == 4'b1000) begin
                    delay <= shifted_data;
                    cycle_count <= 0;
                    next_state <= COUNT;
                end else begin
                    cycle_count <= cycle_count + 1;
                    next_state <= SHIFT;
                end
            end
            COUNT: begin
                counting_reg <= 1;
                if (current_count == delay) begin
                    current_count <= delay;
                    cycle_count <= cycle_count + 1;
                end else if (cycle_count == 10'b1000) begin
                    cycle_count <= 0;
                    current_count <= current_count - 1;
                end else begin
                    cycle_count <= cycle_count + 1;
                end
                if (current_count == 0 && cycle_count == 10'b1000) begin
                    next_state <= DONE;
                end else begin
                    next_state <= COUNT;
                end
            end
            DONE: begin
                done_reg <= 1;
                if (ack == 1'b1) begin
                    next_state <= IDLE;
                    counting_reg <= 0;
                    done_reg <= 0;
                end else begin
                    next_state <= DONE;
                end
            end
        endcase
    end
end

assign count = current_count;
assign counting = counting_reg;
assign done = done_reg;

endmodule
module TopModule(
    input  clk,
    input  reset,
    input  data,
    output [3:0] count,
    output counting,
    output done,
    input  ack
);

reg [3:0] delay;
reg [3:0] current_count;
reg [9:0] total_count;
reg [3:0] remaining_count;
reg counting_reg;
reg done_reg;
reg [3:0] shift_reg;
reg shift_en;

always @(posedge clk) begin
    if (reset) begin
        delay <= 0;
        current_count <= 0;
        total_count <= 0;
        remaining_count <= 0;
        counting_reg <= 0;
        done_reg <= 0;
        shift_reg <= 0;
        shift_en <= 0;
    end else begin
        // IDLE state
        if (~counting_reg && ~done_reg) begin
            if (shift_reg == 4'b1101) begin
                shift_en <= 1;
            end else if (shift_en) begin
                // READ_DELAY state
                shift_reg <= {data, shift_reg[3:1]};
                if (shift_reg[3:0] == 4'b1000) begin
                    delay <= shift_reg[3:0];
                    counting_reg <= 1;
                    total_count <= (delay + 1) * 1000;
                    remaining_count <= delay;
                end
            end
        end

        // COUNTING state
        if (counting_reg) begin
            if (total_count > 0) begin
                total_count <= total_count - 1;
                current_count <= current_count + 1;
                if (current_count == 1000) begin
                    current_count <= 0;
                    remaining_count <= remaining_count - 1;
                end
            end else begin
                counting_reg <= 0;
                done_reg <= 1;
            end
        end

        // DONE state
        if (done_reg) begin
            if (ack) begin
                done_reg <= 0;
                shift_en <= 0;
                shift_reg <= 0;
            end
        end
    end
end

assign count = (counting_reg) ? remaining_count : 4'bxxxx;
assign counting = counting_reg;
assign done = done_reg;

endmodule
module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // 0: A, 1: B, 2: not needed
reg [1:0] count_w; // count of w = 1 in 3 cycles
reg [1:0] cycle_count; // current cycle count

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // A
        count_w <= 0;
        cycle_count <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin // A
                if (s) begin
                    state <= 1; // B
                end
            end
            1: begin // B
                if (cycle_count < 3) begin
                    if (w) begin
                        count_w <= count_w + 1;
                    end
                    cycle_count <= cycle_count + 1;
                end else begin
                    if (count_w == 2) begin
                        z <= 1;
                    end else begin
                        z <= 0;
                    end
                    count_w <= 0;
                    cycle_count <= 0;
                end
            end
        endcase
    end
end

endmodule
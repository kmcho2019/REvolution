module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // 2 states: A (0), B (1)
reg [1:0] count; // count of clock cycles
reg [1:0] w_count; // count of w = 1 in 3 clock cycles

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // reset to state A
        count <= 0;
        w_count <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin // state A
                if (s) begin
                    state <= 1; // move to state B
                    count <= 1;
                    w_count <= w;
                    z <= 0;
                end else begin
                    state <= 0; // stay in state A
                    count <= 0;
                    w_count <= 0;
                    z <= 0;
                end
            end
            1: begin // state B
                count <= count + 1;
                if (w) begin
                    w_count <= w_count + 1;
                end
                if (count == 3) begin
                    if (w_count == 2) begin
                        z <= 1;
                    end else begin
                        z <= 0;
                    end
                    count <= 1;
                    w_count <= w;
                end else begin
                    z <= 0;
                end
            end
        endcase
    end
end

endmodule
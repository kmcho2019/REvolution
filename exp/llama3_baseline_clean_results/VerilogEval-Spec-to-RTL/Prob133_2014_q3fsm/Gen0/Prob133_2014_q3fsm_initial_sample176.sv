module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output z
);

reg [1:0] state; // 0: A, 1: B
reg [1:0] w_count; // count of w being 1 in last two clock cycles
reg [2:0] w_history; // history of w in last three clock cycles

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        w_count <= 0;
        w_history <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin // state A
                if (s) begin
                    state <= 1;
                    w_count <= 0;
                    w_history <= 0;
                end
            end
            1: begin // state B
                w_history <= {w_history[1:0], w};
                w_count <= w_count + w_history[0];
                if (w_history[2]) begin // third clock cycle
                    if (w_count == 2) begin
                        z <= 1;
                    end else begin
                        z <= 0;
                    end
                    w_count <= 0;
                end
            end
        endcase
    end
end

endmodule
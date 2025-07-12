module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // 0: A, 1: B_checking, 2: B_waiting
reg [1:0] w_count; // count of w = 1 in the last 3 cycles
reg [1:0] cycle_count; // current cycle in the 3-cycle window

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // reset to state A
        w_count <= 0;
        cycle_count <= 0;
        z <= 0;
    end
    else begin
        case (state)
            0: begin // state A
                if (s) begin
                    state <= 1; // move to state B
                    w_count <= 0;
                    cycle_count <= 0;
                end
            end
            1: begin // state B_checking
                if (w) begin
                    w_count <= w_count + 1;
                end
                cycle_count <= cycle_count + 1;
                if (cycle_count == 3) begin
                    state <= 2; // move to state B_waiting
                end
            end
            2: begin // state B_waiting
                if (w_count == 2) begin
                    z <= 1;
                end
                else begin
                    z <= 0;
                end
                state <= 1; // move back to state B_checking
                w_count <= 0;
                cycle_count <= 0;
            end
        endcase
    end
end

endmodule
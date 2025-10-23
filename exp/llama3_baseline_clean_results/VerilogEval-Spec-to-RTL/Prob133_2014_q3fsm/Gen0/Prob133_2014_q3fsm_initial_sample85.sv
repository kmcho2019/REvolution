module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // 2 states: A (0) and B (1, 2, 3)
reg [2:0] w_count; // counter for w = 1 in the next three clock cycles
reg [1:0] cycle; // cycle counter for the three clock cycles in state B

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // reset to state A
        w_count <= 0;
        cycle <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin // state A
                if (s) begin
                    state <= 1; // move to state B
                    cycle <= 1;
                end else begin
                    state <= 0; // stay in state A
                end
                w_count <= 0;
                z <= 0;
            end
            1: begin // state B, cycle 1
                if (w) begin
                    w_count <= w_count + 1;
                end
                cycle <= cycle + 1;
                state <= 2;
                z <= 0;
            end
            2: begin // state B, cycle 2
                if (w) begin
                    w_count <= w_count + 1;
                end
                cycle <= cycle + 1;
                state <= 3;
                z <= 0;
            end
            3: begin // state B, cycle 3
                if (w) begin
                    w_count <= w_count + 1;
                end
                if (w_count == 2) begin
                    z <= 1; // set z to 1 if w = 1 in exactly two cycles
                end else begin
                    z <= 0;
                end
                cycle <= 1; // reset cycle counter
                state <= 1; // stay in state B
                w_count <= 0; // reset w counter
            end
        endcase
    end
end

endmodule
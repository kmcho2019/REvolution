module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // 0: State A, 1: State B
reg [1:0] cycle_count; // Counter for the 3 cycles
reg w_count; // Counter for w = 1 in the 3 cycles

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= 0;
        cycle_count <= 0;
        w_count <= 0;
        z <= 0;
    end else begin
        case(state)
            0: begin // State A
                if(s) begin
                    state <= 1;
                    cycle_count <= 1;
                    w_count <= w;
                end
            end
            1: begin // State B
                if(cycle_count < 3) begin
                    cycle_count <= cycle_count + 1;
                    if(w) begin
                        w_count <= w_count + 1;
                    end
                end else begin
                    if(w_count == 2) begin
                        z <= 1;
                    end else begin
                        z <= 0;
                    end
                    // Reset counters and prepare for the next check
                    cycle_count <= 1;
                    w_count <= w;
                end
            end
        endcase
    end
end

endmodule
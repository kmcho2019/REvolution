module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // 0 - state A, 1 - state B
reg [1:0] w_count; // Counter for w = 1 occurrences
reg [1:0] cycle_count; // Counter for 3-cycle window
reg set_z; // Flag to set z in the next cycle

always @(posedge clk) begin
    if(reset) begin
        state <= 0;
        w_count <= 0;
        cycle_count <= 0;
        set_z <= 0;
        z <= 0;
    end
    else begin
        case(state)
            0: begin // state A
                if(s) begin
                    state <= 1;
                    w_count <= 0;
                    cycle_count <= 1;
                    set_z <= 0;
                end
            end
            1: begin // state B
                if(w) begin
                    w_count <= w_count + 1;
                end
                cycle_count <= cycle_count + 1;
                if(cycle_count == 3) begin
                    set_z <= (w_count == 2);
                    w_count <= 0;
                    cycle_count <= 1;
                end
                if(set_z) begin
                    z <= 1;
                    set_z <= 0;
                end
                else begin
                    z <= 0;
                end
                // Transition back to state A if s becomes 0
                if(!s) begin
                    state <= 0;
                end
            end
        endcase
    end
end

endmodule
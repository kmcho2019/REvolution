module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg state; // 0 - state A, 1 - state B
reg [1:0] w_count; // Counter for w = 1
reg [1:0] cycle_count; // Counter for the three cycles

always @(posedge clk) begin
    if(reset) begin
        state <= 0;
        w_count <= 0;
        cycle_count <= 0;
        z <= 0;
    end
    else begin
        case(state)
            0: begin // state A
                if(s) begin
                    state <= 1;
                    w_count <= 0;
                    cycle_count <= 1;
                end
            end
            1: begin // state B
                if(w) begin
                    w_count <= w_count + 1;
                end
                cycle_count <= cycle_count + 1;
                if(cycle_count == 3) begin
                    cycle_count <= 0;
                    if(w_count == 2) begin
                        z <= 1;
                    end
                    else begin
                        z <= 0;
                    end
                    w_count <= 0;
                end
            end
            default: state <= 0;
        endcase
    end
end

endmodule
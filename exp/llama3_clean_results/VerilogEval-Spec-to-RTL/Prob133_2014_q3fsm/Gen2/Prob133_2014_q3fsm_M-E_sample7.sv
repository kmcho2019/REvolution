module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // 0 - state A, 1 - state B1, 2 - state B2, 3 - state B3
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
            1: begin // state B1
                if(w) begin
                    w_count <= w_count + 1;
                end
                cycle_count <= cycle_count + 1;
                if(cycle_count == 1) begin
                    state <= 2;
                end
            end
            2: begin // state B2
                if(w) begin
                    w_count <= w_count + 1;
                end
                cycle_count <= cycle_count + 1;
                if(cycle_count == 2) begin
                    state <= 3;
                end
            end
            3: begin // state B3
                if(w) begin
                    w_count <= w_count + 1;
                end
                if(w_count == 2) begin
                    z <= 1;
                end
                else begin
                    z <= 0;
                end
                state <= 1;
                w_count <= 0;
                cycle_count <= 1;
            end
            default: state <= 0;
        endcase
    end
end

endmodule
module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // 0: STATE_A, 1: STATE_B, 2: STATE_CHECKING
reg [2:0] cycle_count;
reg [1:0] w_count;

always @(posedge clk) begin
    if(reset) begin
        state <= 0;
        z <= 0;
        cycle_count <= 0;
        w_count <= 0;
    end
    else begin
        case(state)
            0: begin // STATE_A
                if(s) begin
                    state <= 1;
                end
            end
            1: begin // STATE_B
                state <= 2;
                cycle_count <= 1;
                w_count <= 0;
            end
            2: begin // STATE_CHECKING
                if(w) begin
                    w_count <= w_count + 1;
                end
                cycle_count <= cycle_count + 1;
                if(cycle_count == 3) begin
                    state <= 1;
                    if(w_count == 2) begin
                        z <= 1;
                    end
                    else begin
                        z <= 0;
                    end
                    cycle_count <= 0;
                    w_count <= 0;
                end
            end
        endcase
    end
end

endmodule
module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

parameter STATE_A = 0;
parameter STATE_B = 1;
parameter CYCLES_TO_CHECK = 3;

reg [1:0] state;
reg [2:0] cycle_count;
reg [1:0] w_count;

always @(posedge clk) begin
    if(reset) begin
        state <= STATE_A;
        cycle_count <= 0;
        w_count <= 0;
        z <= 0;
    end
    else begin
        case(state)
            STATE_A: begin
                if(s) begin
                    state <= STATE_B;
                    cycle_count <= 1;
                    w_count <= 0;
                end
            end
            STATE_B: begin
                if(w) begin
                    w_count <= w_count + 1;
                end
                cycle_count <= cycle_count + 1;
                if(cycle_count == CYCLES_TO_CHECK) begin
                    z <= (w_count == 2)? 1 : 0;
                    w_count <= 0;
                    cycle_count <= 0;
                end
            end
        endcase
    end
end

endmodule
module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg state; // 0: State A, 1: State B
reg [2:0] count; // Counter for 'w' high bits over three cycles
reg [2:0] cycle_count; // Counter for three clock cycles

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= 0;
        count <= 0;
        cycle_count <= 0;
        z <= 0;
    end else begin
        case(state)
            0: begin // State A
                if(s) begin
                    state <= 1;
                end
            end
            1: begin // State B
                if(cycle_count == 3) begin
                    cycle_count <= 0;
                    if(count == 2) begin
                        z <= 1;
                    end else begin
                        z <= 0;
                    end
                end
                if(w) begin
                    count <= count + 1;
                end
                cycle_count <= cycle_count + 1;
            end
        endcase
    end
end

endmodule
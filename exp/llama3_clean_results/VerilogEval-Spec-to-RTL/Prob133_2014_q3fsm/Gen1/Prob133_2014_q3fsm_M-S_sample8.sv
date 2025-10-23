module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z // Declare z as reg for assignment within always block
);

reg state; // 0: State A, 1: State B
reg [1:0] count; // counter for w = 1 in 3 cycles
reg [1:0] cycle_count; // counter for clock cycles

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0;
        count <= 0;
        cycle_count <= 0;
        z <= 0;
    end
    else begin
        case (state)
            0: begin // State A
                if (s) begin
                    state <= 1;
                end
                z <= 0;
            end
            1: begin // State B
                if (cycle_count < 3) begin
                    cycle_count <= cycle_count + 1;
                    if (w) begin
                        count <= count + 1;
                    end
                end
                else begin // cycle_count == 3
                    z <= (count == 2) ? 1 : 0;
                    cycle_count <= 0;
                    count <= 0;
                end
            end
        endcase
    end
end

endmodule
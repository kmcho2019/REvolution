module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg state; // 0=A, 1=B
reg [1:0] cycle;
reg [1:0] w_count;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        cycle <= 0;
        w_count <= 0;
        z <= 0;
    end else begin
        z <= 0; // Default z=0
        
        if (state == 0) begin // State A
            if (s) begin
                state <= 1;
                cycle <= 0;
                w_count <= 0;
            end
        end else begin // State B
            if (cycle == 2) begin // End of 3-cycle window
                z <= (w_count + w) == 2; // Check for exactly 2 w=1's
                cycle <= 0;
                w_count <= 0;
            end else begin
                cycle <= cycle + 1;
                if (w) w_count <= w_count + 1;
            end
        end
    end
end

endmodule
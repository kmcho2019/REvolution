module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] count_w; // Counter for w=1 in a 3-cycle window
reg [1:0] cycle; // Keeps track of the current cycle in the 3-cycle window
reg in_state_b; // Flag to indicate if we are in state B or not

always @(posedge clk) begin
    if (reset) begin
        in_state_b <= 0;
        z <= 0;
        count_w <= 0;
        cycle <= 0;
    end else begin
        if (!in_state_b && s) begin // Transition from A to B
            in_state_b <= 1;
            cycle <= 1;
        end else if (in_state_b) begin // State B logic
            if (cycle < 3) begin // Still within the 3-cycle window
                cycle <= cycle + 1;
                if (w) begin
                    count_w <= count_w + 1;
                end
            end else begin // End of the 3-cycle window, evaluate count_w
                if (count_w == 2) begin
                    z <= 1;
                end else begin
                    z <= 0;
                end
                count_w <= 0; // Reset counter for next window
                cycle <= 1; // Reset cycle counter for next window
            end
        end
    end
end

endmodule
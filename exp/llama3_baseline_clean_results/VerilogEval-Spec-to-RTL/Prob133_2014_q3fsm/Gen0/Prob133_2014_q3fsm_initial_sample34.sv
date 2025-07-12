module TopModule(
    input  clk,
    input  reset,
    input  s,
    input  w,
    output z
);

reg [1:0] state; // 0: State A, 1: State B
reg [1:0] count_w; // Count of w = 1 in the last 3 cycles
reg [1:0] cycle_count; // Current cycle in the 3-cycle window
reg z_reg; // Registered output z

initial begin
    state = 0; // Initialize to state A
    count_w = 0;
    cycle_count = 0;
    z_reg = 0;
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0;
        count_w <= 0;
        cycle_count <= 0;
        z_reg <= 0;
    end else begin
        case (state)
            0: begin // State A
                if (s) begin
                    state <= 1; // Move to state B when s = 1
                    count_w <= 0;
                    cycle_count <= 1;
                end else begin
                    state <= 0; // Stay in state A if s = 0
                end
            end
            1: begin // State B
                if (w) begin
                    count_w <= count_w + 1; // Increment count of w = 1
                end
                cycle_count <= cycle_count + 1; // Increment cycle count
                if (cycle_count == 3) begin // End of 3-cycle window
                    if (count_w == 2) begin
                        z_reg <= 1; // Set z to 1 if count of w = 1 is exactly 2
                    end else begin
                        z_reg <= 0; // Otherwise, set z to 0
                    end
                    count_w <= 0; // Reset count of w = 1
                    cycle_count <= 1; // Reset cycle count
                end
            end
        endcase
    end
end

assign z = z_reg;

endmodule
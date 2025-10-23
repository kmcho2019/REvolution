module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output z
);

reg [1:0] state; // 0: A, 1: B
reg [1:0] count_w; // Count of w = 1 in the last three cycles
reg [1:0] cycle; // Current cycle in the three-cycle window
reg z_reg; // Registered output z

initial begin
    state = 0; // Initialize to state A
    count_w = 0;
    cycle = 0;
    z_reg = 0;
end

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        count_w <= 0;
        cycle <= 0;
        z_reg <= 0;
    end else begin
        case (state)
            0: begin // State A
                if (s) begin
                    state <= 1;
                    count_w <= 0;
                    cycle <= 0;
                    z_reg <= 0;
                end
            end
            1: begin // State B
                if (w) begin
                    count_w <= count_w + 1;
                end
                cycle <= cycle + 1;
                if (cycle == 3) begin
                    if (count_w == 2) begin
                        z_reg <= 1;
                    end else begin
                        z_reg <= 0;
                    end
                    count_w <= 0;
                    cycle <= 0;
                end
            end
        endcase
    end
end

assign z = z_reg;

endmodule
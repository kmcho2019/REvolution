module TopModule(
    input  clk,
    input  reset,
    input  s,
    input  w,
    output z
);

reg [1:0] state; // States: 2'b00 - A, 2'b01 - B, 2'b10 - B (counting w)
reg [1:0] count_w; // Count of w = 1 in the last 3 cycles
reg [1:0] cycle_count; // Count of cycles since entering state B
reg z_reg; // Register for output z

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= 2'b00; // Reset to state A
        count_w <= 2'b00;
        cycle_count <= 2'b00;
        z_reg <= 1'b0;
    end else begin
        case(state)
            2'b00: begin // State A
                if(s) begin
                    state <= 2'b01; // Move to state B
                    count_w <= 2'b00;
                    cycle_count <= 2'b01;
                end else begin
                    state <= 2'b00; // Stay in state A
                end
                z_reg <= 1'b0;
            end
            2'b01: begin // State B (counting cycles and w)
                if(cycle_count == 2'b11) begin // After 3 cycles
                    if(count_w == 2'b10) begin // Exactly 2 w = 1
                        z_reg <= 1'b1;
                    end else begin
                        z_reg <= 1'b0;
                    end
                    state <= 2'b10; // Move to next phase of B
                end else begin
                    if(w) begin
                        count_w <= count_w + 1'b1;
                    end
                    cycle_count <= cycle_count + 1'b1;
                    state <= 2'b01; // Stay in B, counting phase
                end
            end
            2'b10: begin // State B (next phase, reset counters)
                state <= 2'b01; // Back to counting phase
                count_w <= 2'b00;
                cycle_count <= 2'b01;
                if(w) begin
                    count_w <= 1'b1;
                end
            end
            default: begin
                state <= 2'b00; // Default to state A
            end
        endcase
    end
end

assign z = z_reg;

endmodule
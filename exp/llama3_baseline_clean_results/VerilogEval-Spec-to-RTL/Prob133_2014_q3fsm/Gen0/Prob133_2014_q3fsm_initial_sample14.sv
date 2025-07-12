module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

reg [1:0] state; // 0: A, 1: B, 2: B with w counter
reg [1:0] cycle_counter;
reg [1:0] w_counter;
reg z_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0; // A
        cycle_counter <= 0;
        w_counter <= 0;
        z_reg <= 0;
    end else begin
        case (state)
            0: begin // A
                if (s == 1) begin
                    state <= 1; // B
                    cycle_counter <= 1;
                    w_counter <= 0;
                end
            end
            1: begin // B
                cycle_counter <= cycle_counter + 1;
                if (w == 1) begin
                    w_counter <= w_counter + 1;
                end
                if (cycle_counter == 2) begin
                    state <= 2; // B with w counter
                end
            end
            2: begin // B with w counter
                z_reg <= (w_counter == 2) ? 1 : 0;
                state <= 1; // B
                cycle_counter <= 1;
                w_counter <= 0;
            end
        endcase
    end
end

assign z = z_reg;

endmodule
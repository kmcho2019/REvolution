module freq_divbyfrac (
    input         clk,
    input         rst_n,
    output        clk_div
);

parameter MUL2_DIV_CLK = 7; // Total clock cycles for 3.5x division

reg [2:0] cnt; // Counter to keep track of clock cycles
reg [1:0] state; // Finite state machine state
reg         clk_div_int1; // Intermediate divided clock 1
reg         clk_div_int2; // Intermediate divided clock 2
reg         clk_half_delayed; // Half-cycle delayed clock
reg         clk_half_advanced; // Half-cycle advanced clock

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 3'd0;
        state <= 2'd0;
        clk_div_int1 <= 1'd0;
        clk_div_int2 <= 1'd0;
        clk_half_delayed <= 1'd0;
        clk_half_advanced <= 1'd0;
    end else begin
        case (state)
            2'd0: begin // 4-cycle clock period
                if (cnt == 3'd3) begin
                    cnt <= 3'd0;
                    state <= 2'd1;
                    clk_div_int1 <= 1'd1;
                end else begin
                    cnt <= cnt + 1'd1;
                end
            end
            2'd1: begin // 3-cycle clock period
                if (cnt == 3'd2) begin
                    cnt <= 3'd0;
                    state <= 2'd0;
                    clk_div_int2 <= 1'd1;
                end else begin
                    cnt <= cnt + 1'd1;
                end
            end
        endcase

        // Generate half-cycle delayed clock
        if (clk) begin
            clk_half_delayed <= 1'd1;
        end else begin
            clk_half_delayed <= 1'd0;
        end

        // Generate half-cycle advanced clock
        if (!clk) begin
            clk_half_advanced <= 1'd1;
        end else begin
            clk_half_advanced <= 1'd0;
        end

        // Generate phase-shifted divided clocks
        if (state == 2'd0) begin
            if (cnt == 3'd0) begin
                clk_div_int1 <= 1'd0;
            end
            if (cnt == 3'd2) begin
                clk_div_int2 <= 1'd0;
            end
        end else begin
            if (cnt == 3'd0) begin
                clk_div_int2 <= 1'd0;
            end
            if (cnt == 3'd1) begin
                clk_div_int1 <= 1'd0;
            end
        end
    end
end

assign clk_div = clk_div_int1 | clk_div_int2;

endmodule
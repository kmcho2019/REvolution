module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
reg toggle;
reg clk_phase1, clk_phase2;

// Counter and toggle control
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
        toggle <= 1'b0;
    end else begin
        if (toggle ? (counter == 3'd2) : (counter == 3'd3)) begin
            counter <= 3'b0;
            toggle <= ~toggle;
        end else begin
            counter <= counter + 1'b1;
        end
    end
end

// First phase (posedge triggered)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_phase1 <= 1'b0;
    end else begin
        if (counter == 3'b0) begin
            clk_phase1 <= 1'b1;
        end else if (toggle ? (counter == 3'd1) : (counter == 3'd3)) begin
            clk_phase1 <= 1'b0;
        end
    end
end

// Second phase (negedge triggered, half-cycle shifted)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_phase2 <= 1'b0;
    end else begin
        if (counter == 3'b0) begin
            clk_phase2 <= 1'b1;
        end else if (toggle ? (counter == 3'd1) : (counter == 3'd3)) begin
            clk_phase2 <= 1'b0;
        end
    end
end

// Final output combines both phases
assign clk_div = clk_phase1 | clk_phase2;

endmodule
module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  wire        clk,
    input  wire        rst_n,
    output reg         clk_div
);

reg [31:0] cnt; // Counter
reg        div_clk; // Divided clock output

// Reset counter and divided clock output
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 0;
        div_clk <= 1'b0;
    end else begin
        if (cnt < NUM_DIV - 1) begin
            cnt <= cnt + 1;
        end else begin
            cnt <= 0;
            div_clk <= ~div_clk;
        end
    end
end

// Derive final divided clock output
always @(posedge clk) begin
    if (cnt == 0) begin
        clk_div <= div_clk;
    end else begin
        clk_div <= 1'b0;
    end
end

endmodule
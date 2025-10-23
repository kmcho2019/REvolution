module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
reg clk_div1;
reg clk_div2;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
        clk_div1 <= 1'b0;
    end else begin
        if (counter == 3'd6) begin
            counter <= 3'b0;
            clk_div1 <= 1'b1;
        end else begin
            counter <= counter + 1'b1;
            // Toggle every 3 or 4 cycles
            if ((counter == 3'd2) || (counter == 3'd6))
                clk_div1 <= ~clk_div1;
        end
    end
end

// Create phase-shifted version (half-cycle delay)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div2 <= 1'b0;
    end else begin
        clk_div2 <= clk_div1;
    end
end

// Combine both phases
assign clk_div = clk_div1 | clk_div2;

endmodule
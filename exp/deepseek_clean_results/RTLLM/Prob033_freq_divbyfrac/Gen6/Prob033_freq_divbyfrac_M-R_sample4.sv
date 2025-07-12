module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
wire [2:0] next_counter;

// Double-edge counter logic
assign next_counter = (!rst_n) ? 3'b0 : 
                     (counter == 3'd6) ? 3'b0 : counter + 1'b1;

// Update counter on both edges
always @(posedge clk or negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
    end else begin
        counter <= next_counter;
    end
end

// Generate phase-shifted clocks directly from counter
wire clk_div1 = (counter < 3'd4);
wire clk_div2 = (counter > 3'd3) && (counter < 3'd7);

// Combine phases to create fractional division
assign clk_div = clk_div1 | clk_div2;

endmodule
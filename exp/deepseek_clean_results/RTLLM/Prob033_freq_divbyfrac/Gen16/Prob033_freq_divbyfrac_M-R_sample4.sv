module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// Parameters for 3.5x division (7 cycles total)
localparam DIV_VALUE = 7;
localparam COUNTER_WIDTH = 3;

// Main counter (positive edge only)
reg [COUNTER_WIDTH-1:0] counter;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 0;
    end else begin
        counter <= (counter == DIV_VALUE-1) ? 0 : counter + 1;
    end
end

// Phase A (positive edge triggered)
wire phase_a = (counter < (DIV_VALUE/2)) ? 1'b1 : 1'b0;

// Phase B (negative edge triggered)
reg phase_b;
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_b <= 0;
    end else begin
        phase_b <= (counter < (DIV_VALUE/2)) ? 1'b1 : 1'b0;
    end
end

// Direct output combination
assign clk_div = phase_a | phase_b;

endmodule
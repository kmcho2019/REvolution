module freq_diveven (
    input wire clk,
    input wire rst_n,        // Active low synchronous reset
    output reg clk_div       // Divided clock output
);

// Division factor must be even and >= 2
parameter NUM_DIV = 4;

// Parameter validation using assertion
initial begin
    if (NUM_DIV < 2 || NUM_DIV[0] != 1'b0) begin
        $error("NUM_DIV must be even and >= 2. Current value: %0d", NUM_DIV);
        $finish;
    end
end

// Calculate required counter width and max value
localparam COUNTER_WIDTH = $clog2(NUM_DIV/2);
localparam COUNT_MAX = (NUM_DIV/2) - 1;

// Counter register
reg [COUNTER_WIDTH-1:0] cnt;

// Combined counter and clock division logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
        clk_div <= 0;
    end
    else begin
        if (cnt == COUNT_MAX) begin
            cnt <= 0;
            clk_div <= ~clk_div;
        end
        else begin
            cnt <= cnt + 1;
        end
    end
end

endmodule
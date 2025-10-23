module freq_diveven (
    input wire clk,
    input wire rst_n,        // Active low synchronous reset
    output reg clk_div      // Divided clock output
);

// Division factor must be even and >= 2
parameter NUM_DIV = 4;

// Validate parameter at elaboration
initial begin
    if (NUM_DIV < 2 || NUM_DIV[0] != 0) begin
        $error("NUM_DIV must be even and >= 2. Current value: %0d", NUM_DIV);
        $finish;
    end
end

// Calculate required counter width
localparam COUNTER_WIDTH = $clog2(NUM_DIV/2);
localparam COUNT_MAX = (NUM_DIV/2) - 1;

// Up counter with synchronous reset
reg [COUNTER_WIDTH-1:0] cnt;

// Toggle control signal
wire toggle_now = (cnt == COUNT_MAX);

// Sequential logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
        clk_div <= 0;
    end
    else begin
        if (toggle_now) begin
            cnt <= 0;
            clk_div <= ~clk_div;
        end
        else begin
            cnt <= cnt + 1;
        end
    end
end

endmodule
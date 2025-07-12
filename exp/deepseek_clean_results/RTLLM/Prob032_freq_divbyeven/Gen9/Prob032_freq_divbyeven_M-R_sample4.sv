module freq_diveven (
    input wire clk,
    input wire rst_n,        // Active low synchronous reset
    output reg clk_div      // Divided clock output
);

// Division factor must be even and >= 2
parameter NUM_DIV = 4;

// Parameter validation
generate
    if (NUM_DIV < 2 || NUM_DIV[0] != 1'b0) begin
        initial begin
            $error("NUM_DIV must be even and >= 2. Current value: %0d", NUM_DIV);
            $finish;
        end
    end
endgenerate

// Calculate required counter width and max value
localparam COUNTER_WIDTH = $clog2(NUM_DIV/2);
localparam COUNT_MAX = (NUM_DIV/2) - 1;

// Up counter with synchronous reset
reg [COUNTER_WIDTH-1:0] cnt;

// Toggle control signal (continuous assignment)
wire toggle_now = (cnt == COUNT_MAX[COUNTER_WIDTH-1:0]);

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= {COUNTER_WIDTH{1'b0}};  // Explicit zero reset
    end
    else if (toggle_now) begin
        cnt <= {COUNTER_WIDTH{1'b0}};
    end
    else begin
        cnt <= cnt + 1'b1;
    end
end

// Clock division logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div <= 1'b0;
    end
    else if (toggle_now) begin
        clk_div <= ~clk_div;
    end
end

endmodule
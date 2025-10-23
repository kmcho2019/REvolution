module freq_diveven (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

// Division factor must be even and >= 2
parameter NUM_DIV = 4;

// Calculate required counter width (log2(NUM_DIV/2))
localparam COUNTER_WIDTH = $clog2(NUM_DIV/2);
localparam COUNT_MAX = (NUM_DIV/2) - 1;

// Parameter validation
generate
    if (NUM_DIV < 2 || NUM_DIV[0] != 0) begin
        initial begin
            $error("NUM_DIV must be even and >= 2. Current value: %0d", NUM_DIV);
            $finish;
        end
    end
endgenerate

reg [COUNTER_WIDTH-1:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= {COUNTER_WIDTH{1'b0}};
        clk_div <= 1'b0;
    end
    else begin
        if (cnt == COUNT_MAX) begin
            cnt <= {COUNTER_WIDTH{1'b0}};
            clk_div <= ~clk_div;
        end
        else begin
            cnt <= cnt + 1;
        end
    end
end

endmodule
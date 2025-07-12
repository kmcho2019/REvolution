module freq_divbyeven (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

parameter NUM_DIV = 6;  // Must be even number

// Check if NUM_DIV is even at compile time
generate
    if (NUM_DIV % 2 != 0) begin
        ERROR_NUM_DIV_MUST_BE_EVEN error_msg();
    end
endgenerate

// Calculate required counter width based on NUM_DIV
localparam COUNTER_WIDTH = $clog2(NUM_DIV/2);
localparam DIV_HALF = NUM_DIV / 2;

reg [COUNTER_WIDTH-1:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= {COUNTER_WIDTH{1'b0}};
        clk_div <= 1'b0;
    end
    else begin
        if (cnt == DIV_HALF - 1) begin
            cnt <= {COUNTER_WIDTH{1'b0}};
            clk_div <= ~clk_div;
        end
        else begin
            cnt <= cnt + 1;
        end
    end
end

endmodule
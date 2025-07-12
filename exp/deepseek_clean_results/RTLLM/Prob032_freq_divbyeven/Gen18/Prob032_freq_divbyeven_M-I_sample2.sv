module freq_diveven (
    input clk,
    input rst_n,
    output reg clk_div
);

parameter NUM_DIV = 6;  // Must be even number >= 2

// Parameter validation
generate
    if (NUM_DIV < 2 || NUM_DIV[0] != 0) begin
        illegal_parameter_condition illegal();
    end
endgenerate

localparam CNT_WIDTH = $clog2(NUM_DIV/2);
localparam TERM_CNT = NUM_DIV/2 - 1;

reg [CNT_WIDTH-1:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= {CNT_WIDTH{1'b0}};
        clk_div <= 1'b0;
    end
    else begin
        if (cnt == TERM_CNT) begin
            cnt <= {CNT_WIDTH{1'b0}};
            clk_div <= ~clk_div;
        end
        else begin
            cnt <= cnt + 1'b1;
        end
    end
end

endmodule
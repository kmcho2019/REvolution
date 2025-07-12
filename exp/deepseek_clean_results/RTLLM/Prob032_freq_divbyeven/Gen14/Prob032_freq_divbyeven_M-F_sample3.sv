module freq_diveven (
    input clk,
    input rst_n,
    output reg clk_div
);

parameter NUM_DIV = 4; // Must be even number
localparam CNT_WIDTH = $clog2(NUM_DIV/2);
reg [CNT_WIDTH-1:0] cnt;

// Validate parameter
initial begin
    if (NUM_DIV % 2 != 0) begin
        $error("NUM_DIV must be even number");
        $finish;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= {CNT_WIDTH{1'b0}};
        clk_div <= 1'b0;
    end else begin
        if (cnt == (NUM_DIV/2 - 1)) begin
            clk_div <= ~clk_div;
            cnt <= {CNT_WIDTH{1'b0}};
        end else begin
            cnt <= cnt + 1'b1;
        end
    end
end

endmodule
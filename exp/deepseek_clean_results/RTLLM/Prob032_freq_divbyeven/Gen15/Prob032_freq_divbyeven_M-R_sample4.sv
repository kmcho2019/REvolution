module freq_diveven (
    input clk,
    input rst_n,
    output clk_div
);

parameter NUM_DIV = 4; // Must be even number
localparam CNT_WIDTH = $clog2(NUM_DIV/2);

reg [CNT_WIDTH-1:0] cnt;
reg toggle;
reg clk_div_reg;

// Validate parameter
initial begin
    if (NUM_DIV % 2 != 0) begin
        $error("NUM_DIV must be even number");
        $finish;
    end
end

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= {CNT_WIDTH{1'b0}};
    end else begin
        if (cnt == (NUM_DIV/2 - 1)) begin
            cnt <= {CNT_WIDTH{1'b0}};
        end else begin
            cnt <= cnt + 1'b1;
        end
    end
end

// Toggle generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        toggle <= 1'b0;
    end else if (cnt == (NUM_DIV/2 - 1)) begin
        toggle <= ~toggle;
    end
end

// Output generation using continuous assignment
assign clk_div = clk_div_reg;

// Clock divider register
always @(posedge toggle or negedge rst_n) begin
    if (!rst_n) begin
        clk_div_reg <= 1'b0;
    end else begin
        clk_div_reg <= ~clk_div_reg;
    end
end

endmodule
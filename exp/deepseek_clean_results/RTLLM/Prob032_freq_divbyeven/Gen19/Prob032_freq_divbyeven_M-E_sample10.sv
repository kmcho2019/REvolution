module freq_diveven (
    input clk,
    input rst_n,
    output clk_div
);

parameter NUM_DIV = 4;  // Must be even and >= 2

// Validate parameter
initial begin
    if (NUM_DIV[0] || NUM_DIV < 2) begin
        $error("NUM_DIV must be an even number >= 2");
    end
end

reg [3:0] full_cnt;
reg [3:0] half_cnt;
reg clk_div_p;
reg clk_div_n;

// Full period counter
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        full_cnt <= 0;
    end
    else begin
        if (full_cnt == NUM_DIV - 1) begin
            full_cnt <= 0;
        end
        else begin
            full_cnt <= full_cnt + 1;
        end
    end
end

// Half period counter
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        half_cnt <= 0;
    end
    else begin
        if (half_cnt == (NUM_DIV/2 - 1)) begin
            half_cnt <= 0;
        end
        else begin
            half_cnt <= half_cnt + 1;
        end
    end
end

// Positive phase clock
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div_p <= 0;
    end
    else begin
        if (full_cnt == 0) begin
            clk_div_p <= 1;
        end
        else if (half_cnt == (NUM_DIV/2 - 1)) begin
            clk_div_p <= 0;
        end
    end
end

// Negative phase clock
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div_n <= 0;
    end
    else begin
        if (half_cnt == 0) begin
            clk_div_n <= 1;
        end
        else if (full_cnt == (NUM_DIV/2)) begin
            clk_div_n <= 0;
        end
    end
end

// Combined output
assign clk_div = clk_div_p | clk_div_n;

endmodule
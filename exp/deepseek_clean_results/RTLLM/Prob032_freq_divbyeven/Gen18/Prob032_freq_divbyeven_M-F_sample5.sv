module freq_divbyeven (
    input clk,
    input rst_n,
    output clk_div
);

parameter NUM_DIV = 4;  // Division factor (must be even)

// Validate parameter (synthesis-time check)
initial begin
    if (NUM_DIV[0] || NUM_DIV < 2) begin
        $error("NUM_DIV must be an even number >= 2");
    end
end

reg [3:0] cnt;
reg toggle;

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
    end
    else begin
        if (cnt == (NUM_DIV/2 - 1)) begin
            cnt <= 0;
        end
        else begin
            cnt <= cnt + 1;
        end
    end
end

// Toggle logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        toggle <= 0;
    end
    else if (cnt == (NUM_DIV/2 - 1)) begin
        toggle <= ~toggle;
    end
end

// Output assignment
assign clk_div = toggle;

endmodule
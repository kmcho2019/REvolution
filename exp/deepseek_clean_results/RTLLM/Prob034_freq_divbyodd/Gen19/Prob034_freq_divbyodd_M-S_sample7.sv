module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd number
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// Parameter validation
initial if (NUM_DIV % 2 == 0) begin
    $error("NUM_DIV must be odd");
    $finish;
end

localparam HALF_DIV = (NUM_DIV - 1) / 2;
reg [31:0] cnt;
reg clk_pos, clk_neg;

// Counter logic (positive edge only)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
        clk_pos <= 0;
    end else begin
        if (cnt == NUM_DIV - 1) begin
            cnt <= 0;
            clk_pos <= ~clk_pos;
        end else begin
            cnt <= cnt + 1;
            if (cnt == HALF_DIV - 1)
                clk_pos <= ~clk_pos;
        end
    end
end

// Negative edge toggling
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_neg <= 0;
    end else begin
        if (cnt == HALF_DIV)
            clk_neg <= ~clk_neg;
    end
end

// Combine both signals
assign clk_div = clk_pos | clk_neg;

endmodule
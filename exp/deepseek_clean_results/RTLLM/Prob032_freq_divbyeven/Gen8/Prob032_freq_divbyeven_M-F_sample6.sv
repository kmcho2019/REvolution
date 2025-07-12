module freq_diveven (
    input wire clk,
    input wire rst_n,        // Active-low reset
    output reg clk_div      // Divided clock output
);

// Division factor must be even and >= 2
parameter NUM_DIV = 4;      // Default division by 4

// Counter to track clock cycles
reg [3:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 4'b0;
        clk_div <= 1'b0;
    end
    else begin
        if (cnt == (NUM_DIV/2 - 1)) begin
            cnt <= 4'b0;
            clk_div <= ~clk_div;
        end
        else begin
            cnt <= cnt + 1;
        end
    end
end

// Parameter validation
initial begin
    if (NUM_DIV < 2 || NUM_DIV[0] != 0) begin
        $error("Error: NUM_DIV must be even and >= 2. Got %0d", NUM_DIV);
        $finish;
    end
end

endmodule
module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd number
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// Parameter validation
initial begin
    if (NUM_DIV % 2 == 0) begin
        $error("NUM_DIV must be an odd number");
        $finish;
    end
end

localparam HALF_DIV = (NUM_DIV - 1) / 2;

// Dual-edge counter
reg [31:0] counter;
reg toggle;
reg sync_toggle;

// Counter increments on both edges
always @(posedge clk or negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 0;
        toggle <= 0;
    end else begin
        if (counter == NUM_DIV - 1) begin
            counter <= 0;
            toggle <= ~toggle;
        end else if (counter == HALF_DIV) begin
            counter <= counter + 1;
            toggle <= ~toggle;
        end else begin
            counter <= counter + 1;
        end
    end
end

// Synchronize toggle to clock domain
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sync_toggle <= 0;
    end else begin
        sync_toggle <= toggle;
    end
end

assign clk_div = sync_toggle;

endmodule
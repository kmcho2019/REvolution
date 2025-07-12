module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge,
    input enable // Optional enable signal for power saving
);

    reg [7:0] prev_in;
    wire [7:0] edge_detect;
    wire clk_en;

    // Clock gating control
    assign clk_en = enable || (|(in ^ prev_in)); // Enable clock if input changed or module enabled

    // LUT-based edge detection (more FPGA-friendly)
    assign edge_detect = in ^ prev_in;

    // Clock-gated sequential logic
    always @(posedge clk) begin
        if (clk_en) begin
            prev_in <= in;
            anyedge <= edge_detect;
        end
    end

endmodule
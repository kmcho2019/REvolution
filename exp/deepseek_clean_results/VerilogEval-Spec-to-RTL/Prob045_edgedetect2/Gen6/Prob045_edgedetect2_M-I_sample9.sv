module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;
    wire [7:0] edge_detect;
    wire clk_enable;

    // Combinational logic
    assign edge_detect = in ^ prev_in;
    assign clk_enable = (in != prev_in); // Enable only when input changes

    // Sequential logic with clock gating
    always @(posedge clk) begin
        if (clk_enable) begin
            prev_in <= in;
            anyedge <= edge_detect;
        end else begin
            anyedge <= 8'b0; // Clear output when no edges detected
        end
    end

endmodule
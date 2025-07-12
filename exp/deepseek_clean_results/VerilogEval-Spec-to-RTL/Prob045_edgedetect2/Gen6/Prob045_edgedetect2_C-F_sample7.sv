module TopModule #(
    parameter WIDTH = 8
) (
    input clk,
    input enable,        // Optional enable signal for power savings
    input [WIDTH-1:0] in,
    output reg [WIDTH-1:0] anyedge
);

    reg [WIDTH-1:0] prev_in;
    wire [WIDTH-1:0] next_anyedge = in ^ prev_in;

    always @(posedge clk) begin
        if (enable) begin
            prev_in <= in;
            anyedge <= next_anyedge;
        end else begin
            prev_in <= prev_in;  // Maintain state when disabled
            anyedge <= {WIDTH{1'b0}};  // Clear output when disabled
        end
    end

endmodule
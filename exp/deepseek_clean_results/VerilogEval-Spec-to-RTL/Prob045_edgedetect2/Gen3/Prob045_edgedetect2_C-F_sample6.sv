module TopModule #(
    parameter WIDTH = 8
) (
    input clk,
    input [WIDTH-1:0] in,
    output reg [WIDTH-1:0] anyedge,
    input reset  // Optional synchronous reset
);

    reg [WIDTH-1:0] prev_in;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= {WIDTH{1'b0}};
            anyedge <= {WIDTH{1'b0}};
        end else begin
            prev_in <= in;
            anyedge <= in ^ prev_in;
        end
    end

endmodule
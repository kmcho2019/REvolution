module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 8'b0;
            anyedge <= 8'b0;
        end
        else begin
            anyedge <= in ^ prev_in;
            prev_in <= in;
        end
    end

endmodule
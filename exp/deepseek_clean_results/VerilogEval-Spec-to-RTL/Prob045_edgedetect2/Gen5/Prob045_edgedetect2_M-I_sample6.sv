module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;
    wire enable = (in != prev_in);  // Only enable when input changes

    always @(posedge clk) begin
        if (enable) begin
            anyedge <= in ^ prev_in;
            prev_in <= in;
        end
        else begin
            anyedge <= 8'b0;  // Clear output when no change
        end
    end

endmodule
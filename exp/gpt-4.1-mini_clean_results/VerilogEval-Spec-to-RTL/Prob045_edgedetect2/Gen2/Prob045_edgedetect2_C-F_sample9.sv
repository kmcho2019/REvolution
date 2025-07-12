module TopModule (
    input clk,
    input  [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;

    always @(posedge clk) begin
        if (in != prev_in) begin
            anyedge <= in ^ prev_in;  // Detect edges only if input changed
            prev_in <= in;
        end else begin
            anyedge <= 8'b0;          // Clear anyedge if no change
        end
    end

endmodule
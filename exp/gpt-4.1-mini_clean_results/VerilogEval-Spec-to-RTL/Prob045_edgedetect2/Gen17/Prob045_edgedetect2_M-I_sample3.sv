module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    reg [7:0] prev_in;

    always @(posedge clk) begin
        anyedge <= in ^ prev_in;             // Detect edges (1-cycle delayed)
        if (in != prev_in)
            prev_in <= in;                   // Update only if input changed to reduce toggling
    end
endmodule
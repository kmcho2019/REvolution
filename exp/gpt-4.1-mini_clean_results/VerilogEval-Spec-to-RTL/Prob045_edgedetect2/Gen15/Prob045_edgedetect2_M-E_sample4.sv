module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    reg [7:0] prev_in;
    reg [7:0] edge_detect;

    always @(posedge clk) begin
        edge_detect <= in ^ prev_in; // detect edges this cycle
        prev_in <= in;               // store current input for next cycle
        anyedge <= edge_detect;      // output edge info delayed by one cycle
    end
endmodule
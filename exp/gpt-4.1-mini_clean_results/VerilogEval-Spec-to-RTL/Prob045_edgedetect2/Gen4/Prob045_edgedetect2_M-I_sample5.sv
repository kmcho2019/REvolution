module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;
    reg [7:0] edge_detected;

    always @(posedge clk) begin
        edge_detected <= in ^ prev_in;  // detect edges on current cycle
        prev_in <= in;                  // store current input for next cycle comparison
        anyedge <= edge_detected;       // output edge detected from previous cycle (one-cycle delayed)
    end

endmodule
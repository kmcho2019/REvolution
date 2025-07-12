module TopModule (
    input clk,
    input  [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_bit;
    reg [7:0] edge_detected;

    always @(posedge clk) begin
        prev_bit <= in;                    // stage 1: store previous input bits
        edge_detected <= prev_bit ^ in;   // detect edges this cycle
        anyedge <= edge_detected;          // stage 2: output edges detected previous cycle
    end

endmodule
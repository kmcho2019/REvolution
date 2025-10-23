module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] in_d1, in_d2;
    wire [7:0] change_detected;

    // Detect any changes between two consecutive cycles
    assign change_detected = in_d1 ^ in_d2;

    always @(posedge clk) begin
        // Pipeline the input samples
        in_d2 <= in_d1;
        in_d1 <= in;
        
        // Detect positive edges with one cycle delay
        pedge <= change_detected & in_d1;
    end

endmodule
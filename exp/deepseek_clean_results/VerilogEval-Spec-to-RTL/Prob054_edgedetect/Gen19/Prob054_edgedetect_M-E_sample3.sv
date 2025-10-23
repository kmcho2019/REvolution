module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

    // 2-stage shift register for each bit
    reg [7:0] history [1:0];
    
    always @(posedge clk) begin
        history[1] <= history[0];
        history[0] <= in;
    end

    // Edge detection with glitch filtering:
    // Output 1 when current=1 and previous two cycles were 0
    assign pedge = in & ~history[0] & ~history[1];

endmodule
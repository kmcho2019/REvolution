module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

    // Two-stage history registers
    reg [7:0] prev_in;
    reg [7:0] curr_in;

    always @(posedge clk) begin
        prev_in <= curr_in;
        curr_in <= in;
    end

    // Positive edge detection: prev=0 and curr=1
    assign pedge = ~prev_in & curr_in;

endmodule
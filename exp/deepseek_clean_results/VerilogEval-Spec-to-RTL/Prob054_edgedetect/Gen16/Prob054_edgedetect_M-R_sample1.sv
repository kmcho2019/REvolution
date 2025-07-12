module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

    // 2-bit history for each input bit stored in packed arrays
    reg [7:0] history_prev;
    reg [7:0] history_curr;

    always @(posedge clk) begin
        history_prev <= history_curr;
        history_curr <= in;
    end

    // Detect 0->1 transitions (previous=0, current=1)
    assign pedge = ~history_prev & history_curr;

endmodule
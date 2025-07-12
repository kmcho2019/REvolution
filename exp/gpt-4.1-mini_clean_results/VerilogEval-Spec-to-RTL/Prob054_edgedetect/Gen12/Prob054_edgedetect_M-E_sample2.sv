module TopModule (
    input           clk,
    input   [7:0]   in,
    output reg [7:0] pedge
);

    reg [7:0] prev_sample;
    reg [7:0] curr_sample;

    always @(posedge clk) begin
        prev_sample <= curr_sample;
        curr_sample <= in;
        pedge      <= (~prev_sample) & curr_sample;
    end

endmodule
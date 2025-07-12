module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    reg [7:0] curr_sample, prev_sample;
    wire [7:0] edge_detect;

    always @(posedge clk) begin
        prev_sample <= curr_sample;
        curr_sample <= in;
        anyedge <= edge_detect;
    end

    assign edge_detect = curr_sample ^ prev_sample;

endmodule
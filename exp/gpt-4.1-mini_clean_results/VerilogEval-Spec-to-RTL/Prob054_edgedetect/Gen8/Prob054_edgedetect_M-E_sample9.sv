module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] in_pipe1, in_pipe2;
    wire [7:0] edge_detect;

    always @(posedge clk) begin
        in_pipe1 <= in;
        in_pipe2 <= in_pipe1;
        pedge    <= edge_detect;
    end

    assign edge_detect = (~in_pipe2) & in_pipe1;

endmodule
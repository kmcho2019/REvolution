module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

    // 3-stage shift register for each bit
    reg [2:0] history [7:0];
    integer i;

    always @(posedge clk) begin
        for (i = 0; i < 8; i = i + 1) begin
            history[i] <= {history[i][1:0], in[i]};
        end
    end

    // Edge detection: look for "001" pattern
    assign pedge = {
        (history[7][2:1] == 2'b00) & history[7][0],
        (history[6][2:1] == 2'b00) & history[6][0],
        (history[5][2:1] == 2'b00) & history[5][0],
        (history[4][2:1] == 2'b00) & history[4][0],
        (history[3][2:1] == 2'b00) & history[3][0],
        (history[2][2:1] == 2'b00) & history[2][0],
        (history[1][2:1] == 2'b00) & history[1][0],
        (history[0][2:1] == 2'b00) & history[0][0]
    };

endmodule
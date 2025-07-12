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
    
    // Detect pattern "001" in history (two 0s followed by 1)
    wire [7:0] edge_detect;
    generate
        for (genvar j = 0; j < 8; j = j + 1) begin
            assign edge_detect[j] = (history[j][2:1] == 2'b00) & history[j][0];
        end
    endgenerate
    
    assign pedge = edge_detect;

endmodule
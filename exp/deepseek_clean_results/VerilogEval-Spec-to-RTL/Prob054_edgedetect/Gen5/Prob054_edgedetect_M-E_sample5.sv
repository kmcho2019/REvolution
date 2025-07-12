module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    reg [15:0] history;  // 2 bits per input (8x2=16 bits)

    always @(posedge clk) begin
        // Update history by shifting in new values
        history <= {history[14:0], in[7], 
                    history[12:0], in[6],
                    history[10:0], in[5],
                    history[8:0], in[4],
                    history[6:0], in[3],
                    history[4:0], in[2],
                    history[2:0], in[1],
                    in[0]};

        // Detect positive edges (01 pattern)
        pedge <= {history[15:14] == 2'b01,
                 history[13:12] == 2'b01,
                 history[11:10] == 2'b01,
                 history[9:8] == 2'b01,
                 history[7:6] == 2'b01,
                 history[5:4] == 2'b01,
                 history[3:2] == 2'b01,
                 history[1:0] == 2'b01};
    end

endmodule
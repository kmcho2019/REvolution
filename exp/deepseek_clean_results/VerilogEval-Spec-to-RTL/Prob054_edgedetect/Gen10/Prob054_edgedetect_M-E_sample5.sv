module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

    // 2-bit shift register for each input bit
    reg [1:0] history [7:0];
    
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : edge_detectors
            always @(posedge clk) begin
                // Shift in new value
                history[i] <= {history[i][0], in[i]};
            end
            
            // Detect 0->1 transition (01 pattern in history)
            assign pedge[i] = (history[i] == 2'b01);
        end
    endgenerate

endmodule
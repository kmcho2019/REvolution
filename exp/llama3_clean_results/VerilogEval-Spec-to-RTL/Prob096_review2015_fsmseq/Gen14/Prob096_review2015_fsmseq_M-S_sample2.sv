module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [3:0] seq; // Tracks the last 4 bits of the input sequence

always @(posedge clk) begin
    if(reset) begin
        start_shifting <= 0;
        seq <= 4'b0000;
    end else begin
        seq <= {seq[2:0], data}; // Shift in the new data bit
        if(seq == 4'b1101) begin
            start_shifting <= 1; // Set start_shifting if sequence is found
        end else if (start_shifting == 0) begin
            start_shifting <= 0; // No need to set, just ensure it stays 0 if not set
        end
    end
end

endmodule
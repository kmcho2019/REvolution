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
        end else if(start_shifting == 1) begin
            // Once start_shifting is set, keep it set until reset
        end else begin
            start_shifting <= 0; // Default: start_shifting is 0
        end
    end
end

endmodule
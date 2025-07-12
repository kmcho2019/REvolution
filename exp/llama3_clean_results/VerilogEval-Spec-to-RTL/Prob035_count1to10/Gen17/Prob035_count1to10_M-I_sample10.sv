module TopModule (
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] state;

// Initialize state to 1 (binary 0001) to start counting from 1
always @(posedge clk) begin
    if (reset) begin
        state <= 4'd1;
    end else begin
        if (state == 4'd10) begin
            state <= 4'd1;
        end else begin
            state <= state + 4'd1;
        end
    end
end

// Directly assign state to output
assign q = state;

endmodule
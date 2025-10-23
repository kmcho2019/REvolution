module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] count;

// Simplified increment logic with carry chain
wire [3:0] next_count = count + 1'b1;

// Sequential state update
always @(posedge clk) begin
    if (reset) begin
        count <= 4'b0000;
    end
    else begin
        count <= next_count;
    end
end

assign q = count;

endmodule
module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] count;
wire [3:0] next_count;

// Simple increment operation for next state
assign next_count = count + 1'b1;

// Sequential logic with synchronous reset
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
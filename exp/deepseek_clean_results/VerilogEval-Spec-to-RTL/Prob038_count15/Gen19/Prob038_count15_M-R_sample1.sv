module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] count;
wire [3:0] next_count;

// Combinational next state logic
assign next_count[0] = ~count[0];
assign next_count[1] = count[0] ? ~count[1] : count[1];
assign next_count[3:2] = (count[1:0] == 2'b11) ? (count[3:2] + 1'b1) : count[3:2];

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
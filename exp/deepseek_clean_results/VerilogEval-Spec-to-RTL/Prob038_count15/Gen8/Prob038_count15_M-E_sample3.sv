module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] count;
wire [3:0] next_count;

// Explicit carry chain implementation
assign next_count[0] = ~count[0];
assign next_count[1] = reset ? 1'b0 : (count[0] ? ~count[1] : count[1]);
assign next_count[2] = reset ? 1'b0 : ((count[1:0] == 2'b11) ? ~count[2] : count[2]);
assign next_count[3] = reset ? 1'b0 : ((count[2:0] == 3'b111) ? ~count[3] : count[3]);

always @(posedge clk) begin
    count[0] <= reset ? 1'b0 : next_count[0];
    count[1] <= reset ? 1'b0 : next_count[1];
    count[2] <= reset ? 1'b0 : next_count[2];
    count[3] <= reset ? 1'b0 : next_count[3];
end

assign q = count;

endmodule
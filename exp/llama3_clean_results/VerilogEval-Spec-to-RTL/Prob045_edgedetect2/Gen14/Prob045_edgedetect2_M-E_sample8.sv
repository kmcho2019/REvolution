module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

reg [7:0] curr_state;
reg [7:0] prev_state;

always @(posedge clk) begin
    curr_state <= in;
    prev_state <= curr_state;
end

assign anyedge = curr_state ^ prev_state;

endmodule
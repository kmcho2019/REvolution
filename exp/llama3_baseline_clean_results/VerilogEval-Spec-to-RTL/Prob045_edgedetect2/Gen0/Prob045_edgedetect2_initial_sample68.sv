module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] previous_state;

always @(posedge clk) begin
    previous_state <= in;
end

assign anyedge = (in != previous_state);

endmodule
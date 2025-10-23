module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_in; // register to hold previous input value
reg [7:0] anyedge; // output register

always @(posedge clk) begin
    // update previous input value
    prev_in <= in;
    
    // detect any edge and update output
    for (int i = 0; i < 8; i++) begin
        anyedge[i] <= (in[i] != prev_in[i]);
    end
end

endmodule
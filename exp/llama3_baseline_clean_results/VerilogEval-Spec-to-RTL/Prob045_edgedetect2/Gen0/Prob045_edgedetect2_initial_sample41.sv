module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

reg [7:0] prev_in; // register to store previous input values

always @(posedge clk) begin
    // update previous input values
    prev_in <= in;
    
    // check for edges and update output
    for (int i = 0; i < 8; i++) begin
        anyedge[i] <= (in[i] !== prev_in[i]);
    end
end

endmodule
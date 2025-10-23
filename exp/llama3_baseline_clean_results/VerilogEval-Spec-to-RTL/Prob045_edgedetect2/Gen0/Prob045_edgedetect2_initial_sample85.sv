module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_in;  // register to store the previous state
reg [7:0] anyedge;  // output register

always @(posedge clk) begin
    prev_in <= in;  // update the previous state at each positive clock edge
end

always @(*) begin
    for (int i = 0; i < 8; i++) begin
        anyedge[i] = (in[i] !== prev_in[i]);  // set output bit to 1 if a transition is detected
    end
end

endmodule
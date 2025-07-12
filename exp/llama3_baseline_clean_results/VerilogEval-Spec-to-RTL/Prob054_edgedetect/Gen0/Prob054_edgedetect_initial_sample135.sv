module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in; // register to store previous state of input vector

always @(posedge clk) begin
    prev_in <= in; // update previous state at every clock cycle
end

always @(*) begin
    pedge = 8'b0; // initialize output to 0
    for (int i = 0; i < 8; i++) begin
        if (in[i] == 1 && prev_in[i] == 0) begin // detect positive edge transition
            pedge[i] = 1; // set output bit to 1 if transition is detected
        end
    end
end

endmodule
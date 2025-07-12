module TopModule(
    input  clk,
    input  [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in; // register to store the previous state of the input vector

always @(posedge clk) begin
    prev_in <= in; // update the previous state at the positive edge of the clock
end

always @(*) begin
    for (int i = 0; i < 8; i++) begin
        // check for transition from 0 to 1
        pedge[i] = (prev_in[i] == 0) && (in[i] == 1);
    end
end

endmodule
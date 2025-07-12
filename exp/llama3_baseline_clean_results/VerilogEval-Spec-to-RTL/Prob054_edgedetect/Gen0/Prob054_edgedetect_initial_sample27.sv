module TopModule(
    input           clk,
    input   [7:0]    in,
    output  [7:0]    pedge
);

reg    [7:0]    prev_in;  // register to store previous input state

// detect positive edge transitions and set output bits accordingly
always @(posedge clk) begin
    prev_in <= in;  // update previous input state
    for (int i = 0; i < 8; i++) begin
        if (prev_in[i] == 1'b0 && in[i] == 1'b1) begin
            pedge[i] <= 1'b1;  // set output bit if positive edge detected
        end else begin
            pedge[i] <= 1'b0;  // clear output bit otherwise
        end
    end
end

endmodule
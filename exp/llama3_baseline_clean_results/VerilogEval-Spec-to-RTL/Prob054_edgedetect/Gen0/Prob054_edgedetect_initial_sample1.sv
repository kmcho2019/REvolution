module TopModule(
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

reg [7:0] prev_in; // register to store previous value of 'in'

always @(posedge clk) begin
    prev_in <= in; // update previous value on every clock cycle
end

always @(*) begin
    for (int i = 0; i < 8; i++) begin
        if (in[i] == 1 && prev_in[i] == 0) begin
            pedge[i] <= 1; // set output bit to 1 if positive edge detected
        end else begin
            pedge[i] <= 0; // otherwise, set output bit to 0
        end
    end
end

endmodule
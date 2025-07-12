module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in;
reg [7:0] pedge;

always @ (posedge clk) begin
    pedge <= 8'b0; // default output to 0
    for (int i = 0; i < 8; i++) begin
        if (prev_in[i] == 0 && in[i] == 1) begin
            pedge[i] <= 1; // set output to 1 if 0 to 1 transition detected
        end
    end
    prev_in <= in; // update previous input
end

endmodule
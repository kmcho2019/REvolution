module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

reg [7:0] prev_in; // register to store the previous value of in

always @(posedge clk) begin
    pedge <= 0; // Initialize pedge to 0
    prev_in <= in; // update the previous value on every clock cycle
    for (int i = 0; i < 8; i++) begin
        if (prev_in[i] == 0 && in[i] == 1) begin
            pedge[i] <= 1; // Set the corresponding output bit if a positive edge transition is detected
        end
    end
end

endmodule
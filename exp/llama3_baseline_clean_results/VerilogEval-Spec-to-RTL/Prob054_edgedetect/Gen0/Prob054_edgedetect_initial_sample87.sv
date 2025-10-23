module TopModule(
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

reg [7:0] prev_in;

always @(posedge clk) begin
    // Store the current state of the input signal
    prev_in <= in;

    // Detect transitions and set the output bits accordingly
    for (int i = 0; i < 8; i++) begin
        if (in[i] == 1 && prev_in[i] == 0) begin
            pedge[i] <= 1;
        end else begin
            pedge[i] <= 0;
        end
    end
end

endmodule
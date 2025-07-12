module TopModule(
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

reg [7:0] prev_in;  // register to store the previous state of the input signal

always @(posedge clk) begin
    // store the current input as the previous state for the next clock cycle
    prev_in <= in;
    
    // check for 0 to 1 transition and set the output accordingly
    for (int i = 0; i < 8; i++) begin
        pedge[i] <= (prev_in[i] == 1'b0 && in[i] == 1'b1) ? 1'b1 : 1'b0;
    end
end

endmodule
module TopModule(
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

reg [7:0] prev_in;  // register to store the previous state of the input signal

// Update the previous input state at each clock cycle
always @(posedge clk) begin
    prev_in <= in;
end

// Calculate the output using combinational logic
genvar i;
generate
    for (i = 0; i < 8; i++) begin
        assign pedge[i] = (prev_in[i] == 1'b0) && (in[i] == 1'b1);
    end
endgenerate

endmodule
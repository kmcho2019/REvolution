module TopModule (
    input         clk,
    input         reset,
    input  [31:0] in,
    output [31:0] out
);

reg [31:0] prev_in; // register to store the previous input value
reg [31:0] out_reg; // register to store the output value

always @(posedge clk) begin
    if (reset) begin
        out_reg <= 32'd0; // reset the output register
        prev_in <= 32'd0; // reset the previous input register
    end else begin
        // capture the input bits that change from 1 to 0
        for (int i = 0; i < 32; i++) begin
            if (~in[i] && prev_in[i]) begin
                out_reg[i] <= 1'b1; // set the output bit to 1
            end
        end
        prev_in <= in; // update the previous input register
    end
end

assign out = out_reg; // assign the output register to the output port

endmodule
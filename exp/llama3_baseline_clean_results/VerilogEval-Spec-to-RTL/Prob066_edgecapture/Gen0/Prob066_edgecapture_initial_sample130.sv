module TopModule(
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

reg [31:0] prev_in;  // register to store the previous state of the input vector
reg [31:0] out_reg;  // register to store the output

always @(posedge clk) begin
    if (reset) begin
        // reset the output register
        out_reg <= 32'd0;
    end else begin
        // update the previous state register
        prev_in <= in;
        
        // check for transition from 1 to 0 and update the output register
        for (int i = 0; i < 32; i++) begin
            if (prev_in[i] && !in[i]) begin
                out_reg[i] <= 1'b1;
            end
        end
    end
end

assign out = out_reg;

endmodule
module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

reg [31:0] prev_in;  // register to store the previous input
reg [31:0] out_reg;  // register to store the output

always @(posedge clk) begin
    if (reset) begin
        // synchronous reset, clear all registers
        prev_in <= 32'd0;
        out_reg <= 32'd0;
    end else begin
        // store the current input for next clock cycle
        prev_in <= in;
        
        // update output register based on input transition
        for (int i = 0; i < 32; i++) begin
            if (prev_in[i] && !in[i]) begin
                out_reg[i] <= 1'b1;
            end
        end
    end
end

assign out = out_reg;  // assign output register to output port

endmodule
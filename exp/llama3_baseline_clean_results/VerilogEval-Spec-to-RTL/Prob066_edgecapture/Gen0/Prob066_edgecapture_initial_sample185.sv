module TopModule (
    input            clk,
    input            reset,
    input    [31:0]  in,
    output   [31:0]  out
);

reg [31:0] out_reg; // register to store output values
reg [31:0] prev_in; // register to store previous input values

always @(posedge clk) begin
    if (reset) begin // synchronous reset
        out_reg <= 32'd0; // clear output register
    end else begin
        // compare current input with previous input
        for (int i = 0; i < 32; i++) begin
            if (prev_in[i] && !in[i]) begin
                out_reg[i] <= 1'b1; // set output bit to 1 if input changes from 1 to 0
            end
        end
        prev_in <= in; // update previous input
    end
end

assign out = out_reg; // assign output register to output port

endmodule
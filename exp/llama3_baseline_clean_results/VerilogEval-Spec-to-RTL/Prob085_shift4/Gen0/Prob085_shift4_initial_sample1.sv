module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output [3:0] q
);

reg [3:0] q_reg; // internal register for the shift register
assign q = q_reg; // assign the internal register to the output

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        // asynchronous reset, set the shift register to zero
        q_reg <= 4'd0;
    end else if (load) begin
        // load has higher priority, load the shift register with data
        q_reg <= data;
    end else if (ena) begin
        // shift the contents of the shift register to the right
        q_reg <= {1'b0, q_reg[3:1]};
    end else begin
        // do nothing, keep the current value of the shift register
        q_reg <= q_reg;
    end
end

endmodule
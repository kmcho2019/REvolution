// TopModule with Integrated Shift Register
module TopModule(
    input clk,
    input resetn,
    input in,
    output reg out
);

reg [3:0] q;

// Sequential logic for the shift register
always @(posedge clk) begin
    if (!resetn) begin
        q <= 4'b0;
    end else begin
        q <= {q[2:0], in};
    end
end

// Assign output directly from the last bit of the shift register
assign out = q[3];

endmodule
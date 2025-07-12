module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

always @(posedge clk) begin
    if (reset)
        q <= 5'b00001;
    else begin
        q <= {q[3:0], 1'b0} ^ ({5{q[0]}} & 5'b10010);
    end
end

endmodule
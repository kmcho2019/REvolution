module TopModule(
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output [3:0] q
);

reg [3:0] q;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Reset the shift register to zero
        q <= 4'd0;
    end else if (load) begin
        // Load the shift register with data when load is high
        q <= data;
    end else if (ena) begin
        // Shift the shift register right when ena is high and load is low
        q <= {1'b0, q[3:1]};
    end else begin
        // No operation when both load and ena are low
        q <= q;
    end
end

endmodule
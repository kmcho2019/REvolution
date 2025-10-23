module TopModule(
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q
);

always @(posedge areset) begin
    q <= 4'b0; // Reset the shift register to zero when areset is asserted
end

always @(posedge clk) begin
    if (load) begin
        q <= data; // Load data into the shift register when load is asserted
    end else if (ena) begin
        q <= {1'b0, q[3:1]}; // Shift the shift register right when ena is asserted
    end
end

endmodule
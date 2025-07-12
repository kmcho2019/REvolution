module TopModule(
    input clk,
    input reset,
    output reg [3:0] q
);

reg [3:0] ff;

always @(posedge clk) begin
    if (reset) begin
        // Initialize all flip-flops to 0
        ff <= 4'b0001;
    end else begin
        // Shift the bits to the right
        ff <= {ff[0], ff[3:1]};
    end
end

assign q = ff;

endmodule
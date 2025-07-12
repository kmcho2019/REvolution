// D Flip-Flop Module with Active-Low Synchronous Reset
module DFF(
    input clk,
    input resetn,
    input d,
    output reg q
);

always @(posedge clk) begin
    if (!resetn) begin
        q <= 1'b0;
    end else begin
        q <= d;
    end
end

endmodule

// TopModule with Shift Register
module TopModule(
    input clk,
    input resetn,
    input in,
    output reg out
);

reg [3:0] q;

// Instantiating DFFs in a loop for potential synthesis optimization
generate
    for (genvar i = 0; i < 4; i++) begin
        DFF u_dff(
            .clk(clk),
            .resetn(resetn),
            .d(i == 0 ? in : q[i-1]),
            .q(q[i])
        );
    end
endgenerate

assign out = q[3];

endmodule
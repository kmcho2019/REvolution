module DFF (
    input wire clk,
    input wire rst_n,
    input wire d,
    output reg q
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule

module TopModule(output zero);
    // Create a dummy clock signal tied to zero (no toggle)
    wire clk = 1'b0;
    // Active-low reset tied low to hold flip-flop in reset state
    wire rst_n = 1'b0;
    wire d = 1'b1; // D input can be anything, output stuck at zero due to reset

    DFF ff (.clk(clk), .rst_n(rst_n), .d(d), .q(zero));
endmodule
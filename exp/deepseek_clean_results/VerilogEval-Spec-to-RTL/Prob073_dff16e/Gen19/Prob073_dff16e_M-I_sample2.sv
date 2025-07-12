module ByteRegister #(
    parameter WIDTH = 8
) (
    input clk,
    input resetn,
    input enable,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);
    // Clock gating for power optimization
    wire gated_clk;
    assign gated_clk = clk & (enable | !resetn);  // Clock only when needed

    // Explicit next-state logic with clear priority
    always @(posedge gated_clk) begin
        if (!resetn) begin
            q <= {WIDTH{1'b0}};  // Synchronous reset has highest priority
        end else begin
            q <= d;               // Enable-controlled update (enable implied by gated clock)
        end
    end
endmodule

module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output [15:0] q
);

    // Upper byte (bits 15:8) with byteena[1] control
    ByteRegister #(8) upper_byte (
        .clk(clk),
        .resetn(resetn),
        .enable(byteena[1]),
        .d(d[15:8]),
        .q(q[15:8])
    );

    // Lower byte (bits 7:0) with byteena[0] control
    ByteRegister #(8) lower_byte (
        .clk(clk),
        .resetn(resetn),
        .enable(byteena[0]),
        .d(d[7:0]),
        .q(q[7:0])
    );

    // Power optimization directives
    /* synthesis
        power_preserve = "yes";
        power_optimization_effort = "high";
    */

endmodule
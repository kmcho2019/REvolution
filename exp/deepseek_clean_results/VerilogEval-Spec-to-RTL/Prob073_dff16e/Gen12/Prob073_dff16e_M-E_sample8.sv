module ClockGate (
    input clk,
    input enable,
    output gated_clk
);
    // Simple clock gating cell
    reg latch_out;
    always @(*) begin
        if (!clk) latch_out = enable;
    end
    
    assign gated_clk = clk & latch_out;
endmodule

module ByteRegister #(
    parameter WIDTH = 8
) (
    input clk,
    input resetn,
    input enable,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);
    always @(posedge clk) begin
        if (!resetn) begin
            q <= {WIDTH{1'b0}};
        end else if (enable) begin
            q <= d;
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
    wire upper_clk, lower_clk;
    
    // Clock gating for upper byte (bits 15:8)
    ClockGate upper_gate (
        .clk(clk),
        .enable(byteena[1]),
        .gated_clk(upper_clk)
    );
    
    // Clock gating for lower byte (bits 7:0)
    ClockGate lower_gate (
        .clk(clk),
        .enable(byteena[0]),
        .gated_clk(lower_clk)
    );
    
    // Upper byte register bank
    ByteRegister #(8) upper_reg (
        .clk(upper_clk),
        .resetn(resetn),
        .enable(1'b1),  // Always enabled (gating handled by clock)
        .d(d[15:8]),
        .q(q[15:8])
    );
    
    // Lower byte register bank
    ByteRegister #(8) lower_reg (
        .clk(lower_clk),
        .resetn(resetn),
        .enable(1'b1),  // Always enabled (gating handled by clock)
        .d(d[7:0]),
        .q(q[7:0])
    );
endmodule
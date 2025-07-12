module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output [15:0] q
);
    // Clock gating cells
    wire upper_byte_clk;
    wire lower_byte_clk;
    
    // Instantiate clock gating cells
    CLK_GATE upper_clk_gate (
        .CLK(clk),
        .EN(byteena[1] | ~resetn), // Enable during write or reset
        .GCLK(upper_byte_clk)
    );
    
    CLK_GATE lower_clk_gate (
        .CLK(clk),
        .EN(byteena[0] | ~resetn), // Enable during write or reset
        .GCLK(lower_byte_clk)
    );
    
    // Upper byte registers (bits 15:8)
    genvar i;
    generate
        for (i = 8; i < 16; i = i + 1) begin : upper_byte
            DFFSR dff_upper (
                .CLK(upper_byte_clk),
                .RSTN(resetn),
                .D(d[i]),
                .Q(q[i])
            );
        end
    endgenerate
    
    // Lower byte registers (bits 7:0)
    generate
        for (i = 0; i < 8; i = i + 1) begin : lower_byte
            DFFSR dff_lower (
                .CLK(lower_byte_clk),
                .RSTN(resetn),
                .D(d[i]),
                .Q(q[i])
            );
        end
    endgenerate
endmodule

// Standard DFF with synchronous reset
module DFFSR (
    input CLK,
    input RSTN,
    input D,
    output reg Q
);
    always @(posedge CLK) begin
        if (!RSTN) begin
            Q <= 1'b0;
        end else begin
            Q <= D;
        end
    end
endmodule

// Technology-specific clock gating cell
module CLK_GATE (
    input CLK,
    input EN,
    output GCLK
);
    // Implementation depends on target technology
    // For simulation purposes:
    assign GCLK = CLK & EN;
endmodule
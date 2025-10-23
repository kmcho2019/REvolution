module ByteRegister #(
    parameter WIDTH = 8
) (
    input clk,
    input resetn,
    input enable,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);
    (* power_pin = "VDD" *)
    (* ground_pin = "VSS" *)
    wire gated_clk;
    
    // Clock gating cell
    CLKAND2X8 clk_gate (
        .A(clk),
        .B(enable | !resetn), // Always clock during reset
        .Y(gated_clk)
    );

    always @(posedge gated_clk) begin
        if (!resetn) begin
            q <= {WIDTH{1'b0}};
        end else begin
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
    (* power_pin = "VDD" *)
    (* ground_pin = "VSS" *)
    wire reset_buf;
    
    // Shared reset buffer
    BUFX4 reset_buffer (
        .A(resetn),
        .Y(reset_buf)
    );

    // Upper byte (bits 15:8) with byteena[1] control
    ByteRegister #(8) upper_byte (
        .clk(clk),
        .resetn(reset_buf),
        .enable(byteena[1]),
        .d(d[15:8]),
        .q(q[15:8])
    );

    // Lower byte (bits 7:0) with byteena[0] control
    ByteRegister #(8) lower_byte (
        .clk(clk),
        .resetn(reset_buf),
        .enable(byteena[0]),
        .d(d[7:0]),
        .q(q[7:0])
    );

endmodule
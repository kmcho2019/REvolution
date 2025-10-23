// D flip-flop module with clock enable logic to reduce unnecessary toggling
// Updates q only when input d changes, potentially reducing power consumption
module DFF (
    input  wire clk,
    input  wire d,
    output reg  q
);
    wire enable = (d != q);
    always @(posedge clk) begin
        if (enable) begin
            q <= d;
        end
    end
endmodule

// Top-level module instantiating the DFF without additional logic
module TopModule (
    input  wire clk,
    input  wire d,
    output wire q
);
    DFF dff_inst (
        .clk(clk),
        .d(d),
        .q(q)
    );
endmodule
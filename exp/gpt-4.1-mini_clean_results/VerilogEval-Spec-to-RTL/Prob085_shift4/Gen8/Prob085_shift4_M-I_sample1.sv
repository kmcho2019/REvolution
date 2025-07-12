module TopModule (
    input        clk,
    input        areset,
    input        load,
    input        ena,
    input  [3:0] data,
    output reg [3:0] q
);

// Gated clock enables flip-flops only when load or ena is active.
wire gated_clk = clk & (load | ena);

wire [3:0] shift_val = {1'b0, q[3:1]};
wire [3:0] load_val  = data;

always @(posedge gated_clk or posedge areset) begin
    if (areset) begin
        q <= 4'b0;
    end else if (load) begin
        q <= load_val;
    end else if (ena) begin
        q <= shift_val;
    end
    // No else branch for minimal toggling
end

endmodule
module right_shifter (
    input wire clk,
    input wire d,
    input wire enable,
    output wire [7:0] q
);

// Clock gating
wire gated_clk;
assign gated_clk = clk & enable;

// Individual flip-flop instances
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : shift_reg
        wire din;
        if (i == 7) begin
            assign din = d;  // MSB gets new input
        end else begin
            assign din = q[i+1];  // Others get value from next bit
        end
        
        DFF dff_inst (
            .clk(gated_clk),
            .d(din),
            .q(q[i])
        );
    end
endgenerate

endmodule

// Basic D Flip-Flop module
module DFF (
    input wire clk,
    input wire d,
    output reg q
);
always @(posedge clk) begin
    q <= d;
end
endmodule
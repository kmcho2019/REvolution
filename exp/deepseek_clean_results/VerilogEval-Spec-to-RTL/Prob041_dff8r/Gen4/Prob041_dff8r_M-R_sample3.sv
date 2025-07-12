module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

// Declare wires for each flip-flop output
wire [7:0] q_wire;

// Generate 8 D flip-flops with synchronous reset
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : dff_gen
        always @(posedge clk) begin
            if (reset) begin
                q_wire[i] <= 1'b0;
            end else begin
                q_wire[i] <= d[i];
            end
        end
    end
endgenerate

// Assign output
assign q = q_wire;

endmodule
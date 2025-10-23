module TopModule (
    input        clk,
    input        areset,
    input  [7:0] d,
    output [7:0] q
);

// Declare a register array to hold the flip-flop outputs internally
reg [7:0] q_reg;

assign q = q_reg;

// Instantiate 8 D flip-flops with asynchronous active-high reset using generate
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : dff_array
        always @(posedge clk or posedge areset) begin
            if (areset)
                q_reg[i] <= 1'b0;
            else
                q_reg[i] <= d[i];
        end
    end
endgenerate

endmodule
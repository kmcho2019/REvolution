module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

wire [511:0] next_q;
reg clk_en;

// Clock gating control
always @(*) begin
    clk_en = load || (|next_q ^ |q);  // Enable clock if loading or state will change
end

// Operand-isolated XOR implementation
genvar i;
generate
    for (i = 0; i < 512; i = i + 1) begin : rule90_cells
        // Shared boundary condition logic for adjacent cells
        wire left = (i == 0) ? 1'b0 : q[i-1];
        wire right = (i == 511) ? 1'b0 : q[i+1];
        
        // Operand isolation: only compute when not loading
        assign next_q[i] = load ? 1'b0 : (left ^ right);
    end
endgenerate

// Clock-gated flip-flop implementation
always @(posedge clk) begin
    if (clk_en) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end
end

endmodule
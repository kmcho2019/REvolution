module JC_counter (
    input  wire        clk,
    input  wire        rst_n,
    output reg [63:0]  Q
);

// Clock enable tied to 1 for clarity and potential power gating
wire ce = 1'b1;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
    end else if (ce) begin
        // Shift right by one bit:
        // Q[i] <= Q[i+1] for i=0 to 62
        // Q[63] <= ~Q[0]
        Q[62:0] <= Q[63:1];
        Q[63]   <= ~Q[0];
    end
end

endmodule
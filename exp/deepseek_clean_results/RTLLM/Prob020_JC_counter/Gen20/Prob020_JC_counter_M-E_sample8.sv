module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

reg [31:0] upper_half;
reg [31:0] lower_half;
wire upper_msb = ~lower_half[0];  // Inverted feedback
wire lower_msb = ~upper_half[0];  // Cross-coupled phase

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        upper_half <= 32'b0;
        lower_half <= 32'b0;
    end else begin
        // Parallel update with phase-shifted feedback
        upper_half <= {upper_msb, upper_half[31:1]};
        lower_half <= {lower_msb, lower_half[31:1]};
    end
end

// Combine halves for output
always @(*) begin
    Q = {upper_half, lower_half};
end

endmodule
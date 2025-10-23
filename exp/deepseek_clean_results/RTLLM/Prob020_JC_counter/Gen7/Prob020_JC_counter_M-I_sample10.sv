module JC_counter (
    input clk,
    input rst_n,
    input enable,        // New enable signal for power optimization
    output reg [63:0] Q
);

reg [31:0] first_stage;  // Pipeline register for first 32-bit shift

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
        first_stage <= 32'b0;
    end
    else if (enable) begin
        // First pipeline stage: shift upper 32 bits and insert ~Q[0]
        first_stage <= {~Q[0], Q[63:33]};
        
        // Second pipeline stage: combine with lower 32 bits
        Q <= {first_stage, Q[32:1]};
    end
    // When disabled, maintain current state
end

endmodule
module JC_counter (
    input clk,
    input rst_n,
    input enable,       // New enable signal
    output reg [63:0] Q
);

reg [31:0] first_stage;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
        first_stage <= 32'b0;
    end
    else if (enable) begin
        // First pipeline stage: process upper 32 bits
        first_stage <= {~Q[0], Q[63:33]};
        
        // Second pipeline stage: process lower 32 bits
        Q <= {first_stage, Q[32:1]};
    end
end

endmodule
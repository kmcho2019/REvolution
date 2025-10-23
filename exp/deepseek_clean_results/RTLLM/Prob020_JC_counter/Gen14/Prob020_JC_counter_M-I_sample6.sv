module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// Optional clock gating control
wire enable = 1'b1;  // Can be driven externally if needed

// Pipeline registers
reg [31:0] upper_stage;
reg [31:0] lower_stage;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
        upper_stage <= 32'b0;
        lower_stage <= 32'b0;
    end
    else if (enable) begin
        // First pipeline stage: process upper and lower halves separately
        upper_stage <= {~Q[0], Q[63:33]};
        lower_stage <= Q[32:1];
        
        // Second pipeline stage: combine results
        Q <= {upper_stage, lower_stage};
    end
end

endmodule
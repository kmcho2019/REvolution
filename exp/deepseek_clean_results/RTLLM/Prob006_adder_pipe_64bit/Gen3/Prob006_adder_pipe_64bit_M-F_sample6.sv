module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Pipeline registers
reg [15:0] sum0, sum1, sum2, sum3;
reg carry0, carry1, carry2, carry3;
reg [3:0] en_pipe;

// Internal signals
wire [16:0] seg0, seg1, seg2, seg3;

// Segment 0 (bits 0-15)
assign seg0 = {1'b0, adda[15:0]} + {1'b0, addb[15:0]};

// Segment 1 (bits 16-31)
assign seg1 = {1'b0, adda[31:16]} + {1'b0, addb[31:16]} + carry0;

// Segment 2 (bits 32-47)
assign seg2 = {1'b0, adda[47:32]} + {1'b0, addb[47:32]} + carry1;

// Segment 3 (bits 48-63)
assign seg3 = {1'b0, adda[63:48]} + {1'b0, addb[63:48]} + carry2;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        sum0 <= 16'b0;
        sum1 <= 16'b0;
        sum2 <= 16'b0;
        sum3 <= 16'b0;
        carry0 <= 1'b0;
        carry1 <= 1'b0;
        carry2 <= 1'b0;
        carry3 <= 1'b0;
        en_pipe <= 4'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Pipeline stage 0
        sum0 <= seg0[15:0];
        carry0 <= seg0[16];
        en_pipe[0] <= i_en;
        
        // Pipeline stage 1
        sum1 <= seg1[15:0];
        carry1 <= seg1[16];
        en_pipe[1] <= en_pipe[0];
        
        // Pipeline stage 2
        sum2 <= seg2[15:0];
        carry2 <= seg2[16];
        en_pipe[2] <= en_pipe[1];
        
        // Pipeline stage 3
        sum3 <= seg3[15:0];
        carry3 <= seg3[16];
        en_pipe[3] <= en_pipe[2];
        
        // Final output stage
        result <= {carry3, sum3, sum2, sum1, sum0};
        o_en <= en_pipe[3];
    end
end

endmodule
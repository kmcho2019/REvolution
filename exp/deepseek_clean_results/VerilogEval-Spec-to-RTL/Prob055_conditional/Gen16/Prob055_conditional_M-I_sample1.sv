module TopModule (
    input clk,          // Added clock input
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output reg [7:0] min
);

    // Pipeline registers
    reg [7:0] stage1_ab;
    reg [7:0] stage1_cd;
    
    // FSM state
    reg state;
    
    // Shared comparator
    wire [7:0] cmp_result = (state == 0) ? 
                          ((a < b) ? a : b) : 
                          ((stage1_ab < stage1_cd) ? stage1_ab : stage1_cd);

    always @(posedge clk) begin
        case (state)
            0: begin
                // First stage: compare a/b and c/d in parallel
                stage1_ab <= (a < b) ? a : b;
                stage1_cd <= (c < d) ? c : d;
                state <= 1;
            end
            1: begin
                // Second stage: compare intermediate results
                min <= cmp_result;
                state <= 0;
            end
        endcase
    end

endmodule
module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Extended register with boundary conditions
    reg [513:0] extended_q;
    
    // Next state computation pipeline registers
    reg [511:0] next_q;
    reg [511:0] stage1, stage2;
    
    // Boundary handling
    always @(posedge clk) begin
        if (load) begin
            extended_q <= {1'b0, data, 1'b0};
        end else begin
            extended_q <= {1'b0, next_q, 1'b0};
        end
    end
    
    // Pipeline stage 1: Capture neighbors
    always @(posedge clk) begin
        for (integer i = 0; i < 512; i = i + 1) begin
            stage1[i] <= (extended_q[i+2] ^ extended_q[i]) | 
                        (~extended_q[i+1] & (extended_q[i+2] | extended_q[i]));
        end
    end
    
    // Pipeline stage 2: Final computation
    always @(posedge clk) begin
        next_q <= stage1;
        q <= next_q;
    end

endmodule
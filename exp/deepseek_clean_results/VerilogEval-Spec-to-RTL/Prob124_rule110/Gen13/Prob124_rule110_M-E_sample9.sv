module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Extended register with boundary bits
    reg [513:0] extended_q;

    // Next state computation
    wire [511:0] next_q;
    
    // Compute next state in two stages
    wire [511:0] stage1;
    wire [511:0] stage2;

    // Stage 1: Compute intermediate results for each possible 3-bit window
    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : window_stage1
            assign stage1[i] = ~(extended_q[i+2] & extended_q[i+1] & extended_q[i]) & 
                              ~(extended_q[i+2] & ~extended_q[i+1] & ~extended_q[i]);
        end
    endgenerate

    // Stage 2: Final combination
    generate
        for (i = 0; i < 512; i = i + 1) begin : window_stage2
            assign stage2[i] = stage1[i] | (extended_q[i+1] & (extended_q[i+2] | extended_q[i]));
            assign next_q[i] = stage2[i];
        end
    endgenerate

    // Update extended register (includes boundary bits)
    always @(posedge clk) begin
        if (load) begin
            extended_q <= {1'b0, data, 1'b0};
        end else begin
            extended_q <= {1'b0, next_q, 1'b0};
        end
    end

    // Output the main register
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule
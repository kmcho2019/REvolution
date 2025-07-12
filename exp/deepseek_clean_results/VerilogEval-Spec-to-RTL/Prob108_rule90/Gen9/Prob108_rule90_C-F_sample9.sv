module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] next_q;
    reg update_en;  // Clock gating control

    // Clock gating logic
    always @(posedge clk) begin
        update_en <= ~load;  // Enable updates unless loading
    end

    // Process in 4-bit chunks for better timing
    genvar i;
    generate
        for (i = 0; i < 512; i = i + 4) begin: rule90_chunks
            // Boundary handling
            wire [3:0] left = (i == 0) ? 4'b0 : {q[i-1], q[i], q[i+1], q[i+2]};
            wire [3:0] right = (i >= 508) ? {q[i+1], q[i+2], q[i+3], 1'b0} : 
                                          {q[i+1], q[i+2], q[i+3], q[i+4]};
            
            // Shared XOR resources within chunk
            always @(*) begin
                next_q[i]   = left[0] ^ right[0];
                next_q[i+1] = left[1] ^ right[1];
                next_q[i+2] = left[2] ^ right[2];
                if (i+3 < 512) begin
                    next_q[i+3] = left[3] ^ right[3];
                end
            end
        end
    endgenerate

    // Synchronous update with clock gating
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (update_en) begin
            q <= next_q;
        end
    end

endmodule
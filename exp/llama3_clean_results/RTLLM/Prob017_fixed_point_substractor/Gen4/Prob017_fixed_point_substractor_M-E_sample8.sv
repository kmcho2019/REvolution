module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input  [N-1:0] a,
    input  [N-1:0] b,
    output reg [N-1:0] c
);

// Define the prefix generation unit
reg [N-1:0] pgu_result;

// Define the borrow propagation unit
reg [N-1:0] bpu_result;

// Define the result computation unit
reg [N-1:0] rcu_result;

// Define the speculative execution unit
reg [N-1:0] spe_result;

// Prefix generation unit
always @(a or b) begin
    for (int i = 0; i < N; i++) begin
        if (a[i] == 1'b1 && b[i] == 1'b0) begin
            pgu_result[i] = 1'b1;
        end else if (a[i] == 1'b0 && b[i] == 1'b1) begin
            pgu_result[i] = 1'b0;
        end else begin
            pgu_result[i] = 1'b0;
        end
    end
end

// Borrow propagation unit
always @(pgu_result) begin
    for (int i = 0; i < N; i++) begin
        if (pgu_result[i] == 1'b1) begin
            bpu_result[i] = 1'b1;
        end else if (i > 0 && bpu_result[i-1] == 1'b1) begin
            bpu_result[i] = 1'b1;
        end else begin
            bpu_result[i] = 1'b0;
        end
    end
end

// Result computation unit
always @(bpu_result or a or b) begin
    for (int i = 0; i < N; i++) begin
        if (bpu_result[i] == 1'b1) begin
            rcu_result[i] = ~a[i] & b[i];
        end else if (a[i] == 1'b1 && b[i] == 1'b0) begin
            rcu_result[i] = 1'b1;
        end else if (a[i] == 1'b0 && b[i] == 1'b1) begin
            rcu_result[i] = 1'b0;
        end else begin
            rcu_result[i] = a[i] ^ b[i];
        end
    end
end

// Speculative execution unit
always @(rcu_result) begin
    for (int i = 0; i < N; i++) begin
        if (rcu_result[i] == 1'b1 && bpu_result[i] == 1'b0) begin
            spe_result[i] = 1'b1;
        end else if (rcu_result[i] == 1'b0 && bpu_result[i] == 1'b1) begin
            spe_result[i] = 1'b0;
        end else begin
            spe_result[i] = rcu_result[i];
        end
    end
end

// Final result
always @(spe_result) begin
    c = spe_result;
end

endmodule
module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

    // Edge detectors for j and k
    reg j_prev, k_prev;
    wire j_rise = j && !j_prev;
    wire k_rise = k && !k_prev;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            out <= 1'b0;
            j_prev <= 1'b0;
            k_prev <= 1'b0;
        end else begin
            j_prev <= j;
            k_prev <= k;
            
            // Toggle logic
            if (j_rise && !out) begin  // Only toggle from OFF to ON on j rising edge
                out <= 1'b1;
            end else if (k_rise && out) begin  // Only toggle from ON to OFF on k rising edge
                out <= 1'b0;
            end
        end
    end

endmodule
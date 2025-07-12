module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    reg out_reg;
    reg j_prev, k_prev;
    wire j_rise, k_rise;

    // Edge detection
    assign j_rise = j & ~j_prev;
    assign k_rise = k & ~k_prev;

    always @(posedge clk) begin
        if (reset) begin
            out_reg <= 1'b0;
            j_prev <= 1'b0;
            k_prev <= 1'b0;
        end else begin
            j_prev <= j;
            k_prev <= k;
            
            if (~out_reg && j_rise)
                out_reg <= 1'b1;
            else if (out_reg && k_rise)
                out_reg <= 1'b0;
        end
    end

    assign out = out_reg;

endmodule
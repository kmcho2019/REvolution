module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    reg state;
    reg prev_j, prev_k;

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;
        end
        else begin
            prev_j <= j;
            prev_k <= k;
            
            if (j != prev_j || k != prev_k) begin  // Only evaluate transitions if inputs changed
                case (state)
                    1'b0: state <= j ? 1'b1 : 1'b0;
                    1'b1: state <= k ? 1'b0 : 1'b1;
                endcase
            end
        end
    end

    assign out = state;

endmodule
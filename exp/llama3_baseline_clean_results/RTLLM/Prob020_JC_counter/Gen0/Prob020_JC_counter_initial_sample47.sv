module JC_counter(
    input   logic           clk,
    input   logic           rst_n,
    output  logic [63:0]    Q
);

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'd0;
    end
    else begin
        if (Q[0] == 1'b0) begin
            Q <= {1'b1, Q[63:1]};
        end
        else begin
            Q <= {1'b0, Q[63:1]};
        end
    end
end

endmodule
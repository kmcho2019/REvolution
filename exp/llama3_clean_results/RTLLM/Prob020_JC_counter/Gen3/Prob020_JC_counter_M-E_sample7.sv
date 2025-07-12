module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

reg [63:0] incr_seq;
reg [63:0] decr_seq;

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'd0;
        incr_seq <= 64'd0;
        decr_seq <= 64'd0;
    end else begin
        // Update increment sequence
        incr_seq <= {1'b1, incr_seq[63:1]};
        
        // Update decrement sequence
        decr_seq <= {1'b0, decr_seq[63:1]};
        
        // Select between increment and decrement sequences based on Q[0]
        if (Q[0] == 1'b0) begin
            Q <= incr_seq;
        end else begin
            Q <= decr_seq;
        end
    end
end

endmodule
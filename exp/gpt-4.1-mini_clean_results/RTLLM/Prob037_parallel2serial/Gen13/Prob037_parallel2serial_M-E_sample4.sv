module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output       dout
);

    reg [1:0] cnt;

    // dout is the bit of d indexed by cnt (MSB at cnt=3)
    assign dout = d[cnt];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt       <= 2'd3;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd0) begin
                cnt       <= 2'd3;   // Reset counter for new parallel data word
                valid_out <= 1'b1;   // valid_out indicates MSB just output last cycle
            end else begin
                cnt       <= cnt - 1'b1;
                valid_out <= 1'b0;
            end
        end
    end

endmodule
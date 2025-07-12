module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;

genvar i;
generate
    for (i = 0; i < 512; i++) begin
        wire next_state;
        if (i == 0) begin
            assign next_state = q_reg[i + 1];
        end else if (i == 511) begin
            assign next_state = q_reg[i - 1];
        end else begin
            assign next_state = q_reg[i - 1] ^ q_reg[i + 1];
        end
        assign q[i] = load ? data[i] : next_state;
    end
endgenerate

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        q_reg <= q;
    end
end

endmodule
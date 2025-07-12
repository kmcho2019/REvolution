module Rule110Cell(
    input left,
    input center,
    input right,
    output next_state
);

always @(*) begin
    next_state = (left && center && !right) || 
                 (left && !center && right) || 
                 (!left && center && right) || 
                 (!left && center && !right) || 
                 (!left && !center && right);
end

endmodule

module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] current_state;

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        for (int i = 0; i < 512; i++) begin
            reg left;
            reg right;
            if (i == 0) begin
                left = 1'b0;
            end else begin
                left = current_state[i - 1];
            end

            if (i == 511) begin
                right = 1'b0;
            end else begin
                right = current_state[i + 1];
            end

            Rule110Cell cell(
                .left(left),
                .center(current_state[i]),
                .right(right),
                .next_state(current_state[i])
            );
        end
    end
end

assign q = current_state;

endmodule
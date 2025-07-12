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
        reg [511:0] next_state;
        for (int i = 0; i < 512; i++) begin
            reg left, center, right;

            left = (i == 0) ? 1'b0 : current_state[i - 1];
            center = current_state[i];
            right = (i == 511) ? 1'b0 : current_state[i + 1];

            next_state[i] = (left && center && right) ? 1'b0 :
                            (left && center && !right) ? 1'b1 :
                            (left && !center && right) ? 1'b1 :
                            (left && !center && !right) ? 1'b0 :
                            (!left && center && right) ? 1'b1 :
                            (!left && center && !right) ? 1'b1 :
                            (!left && !center && right) ? 1'b1 :
                            (!left && !center && !right) ? 1'b0 : 1'b0;

        end
        current_state <= next_state;
    end
end

assign q = current_state;

endmodule
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
            reg left, center, right;
            if (i == 0) begin
                left = 1'b0;
            end else begin
                left = current_state[i - 1];
            end
            center = current_state[i];
            if (i == 511) begin
                right = 1'b0;
            end else begin
                right = current_state[i + 1];
            end
            current_state[i] <= left ^ right;
        end
    end
end

assign q = current_state;

endmodule
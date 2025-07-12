module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] state;

// Initialize the output
assign q = state;

// Load data when load is high
always @(posedge clk) begin
    if (load) begin
        state <= data;
    end else begin
        // Calculate the next state
        for (int i = 0; i < 512; i++) begin
            reg left, center, right;
            if (i == 0) begin
                left = 1'b0;
            end else begin
                left = state[i - 1];
            end
            center = state[i];
            if (i == 511) begin
                right = 1'b0;
            end else begin
                right = state[i + 1];
            end
            // Apply Rule 90
            state[i] <= left ^ right;
        end
    end
end

endmodule
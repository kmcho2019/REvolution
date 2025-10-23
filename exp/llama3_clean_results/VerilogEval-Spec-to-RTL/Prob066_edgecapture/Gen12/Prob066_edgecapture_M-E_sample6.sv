module TopModule(
    input  clk,
    input  reset,
    input  [31:0] in,
    output reg [31:0] out
);

reg [31:0] state;

always @(posedge clk) begin
    if (reset) begin
        state <= 32'd0;
    end else begin
        for (int i = 0; i < 32; i++) begin
            if (in[i] == 0 && state[i] == 0) begin
                // If current bit is 0 and state is 0, check previous state
                if (in[i]!= state[i]) begin
                    state[i] <= 1'b1; // Set state to 1 if transition from 1 to 0
                end
            end
        end
    end
end

always @(*) begin
    out = state; // Continuous assignment to output
end

endmodule
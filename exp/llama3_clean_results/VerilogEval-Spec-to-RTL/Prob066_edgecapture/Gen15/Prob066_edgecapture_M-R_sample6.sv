module TopModule(
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] state;

    // Update state
    always @(posedge clk) begin
        if (reset) begin
            state <= 32'b0;
        end else begin
            for (int i = 0; i < 32; i++) begin
                if (!in[i] && state[i] == 0) begin
                    state[i] <= 1'b1;
                end
            end
        end
    end

    // Generate output
    always @(*) begin
        for (int i = 0; i < 32; i++) begin
            if (state[i] == 1'b1) begin
                out[i] = 1'b1;
            end else begin
                out[i] = 1'b0;
            end
        end
    end

endmodule
module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

reg [31:0] prev_in; // Register to store previous input value

always @(posedge clk) begin
    if (reset) begin // Synchronous reset
        out <= 32'd0;
    end else begin
        prev_in <= in; // Store current input value
        for (int i = 0; i < 32; i++) begin
            if (prev_in[i] == 1'b1 && in[i] == 1'b0) begin // Check for transition from 1 to 0
                out[i] <= 1'b1; // Capture the transition
            end
        end
    end
end

endmodule
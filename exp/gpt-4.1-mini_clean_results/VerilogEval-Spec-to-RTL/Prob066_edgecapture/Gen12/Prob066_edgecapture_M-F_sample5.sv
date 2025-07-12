module TopModule (
    input wire clk,
    input wire reset,
    input wire [31:0] in,
    output reg [31:0] out
);

    // Two-stage synchronizer for asynchronous input
    reg [31:0] sync_in_stage1;
    reg [31:0] sync_in;

    reg [31:0] prev_in;

    always @(posedge clk) begin
        if (reset) begin
            sync_in_stage1 <= 32'b0;
            sync_in <= 32'b0;
            prev_in <= 32'b0;
            out <= 32'b0;
        end else begin
            // Synchronize 'in' into clock domain
            sync_in_stage1 <= in;
            sync_in <= sync_in_stage1;

            // Detect falling edges on synchronized inputs
            out <= out | (prev_in & ~sync_in);

            // Update previous input with synchronized value
            prev_in <= sync_in;
        end
    end

endmodule
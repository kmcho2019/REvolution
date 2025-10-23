module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;

    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
            prev_in <= 32'b0;
        end
        else begin
            // First stage: store current input
            prev_in <= in;
            
            // Second stage: detect falling edges and maintain state
            out <= out | (prev_in & ~in);
        end
    end

endmodule
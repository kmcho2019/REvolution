module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;

    // Sequential block for storing previous input
    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
        end
        else begin
            prev_in <= in;
        end
    end

    // Sequential block for output logic
    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
        end
        else begin
            // Detect falling edges and latch the output
            out <= out | (prev_in & ~in);
        end
    end

endmodule
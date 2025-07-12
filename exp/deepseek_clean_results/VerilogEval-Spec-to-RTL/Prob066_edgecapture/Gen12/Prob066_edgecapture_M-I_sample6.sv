module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    // Packed array for efficient synthesis (2 bits x 32 channels)
    reg [63:0] history;  // history[2*i+1:2*i] stores previous and current for bit i

    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
            history <= 64'b0;
        end else begin
            // Update history - shift current to previous, store new input
            history <= {history[62:0], in};

            // Detect falling edges and set sticky outputs
            for (integer i = 0; i < 32; i = i + 1) begin
                if (history[2*i +: 2] == 2'b10) begin
                    out[i] <= 1'b1;
                end
            end
        end
    end

endmodule
module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    // 2-bit history registers for each input bit
    reg [1:0] history [31:0];
    
    // Capture registers
    reg [31:0] captured;
    
    // Output assignment
    assign out = captured;

    integer i;
    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1) begin
                history[i] <= 2'b00;
                captured[i] <= 1'b0;
            end
        end
        else begin
            for (i = 0; i < 32; i = i + 1) begin
                // Shift in new value (MSB is newest)
                history[i] <= {history[i][0], in[i]};
                
                // Detect falling edge (1 in previous cycle, 0 in current)
                if (history[i] == 2'b10) begin
                    captured[i] <= 1'b1;
                end
            end
        end
    end

endmodule
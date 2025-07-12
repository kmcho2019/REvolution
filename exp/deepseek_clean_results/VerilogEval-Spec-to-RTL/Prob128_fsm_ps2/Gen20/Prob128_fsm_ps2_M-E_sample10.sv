module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [7:0] buffer [0:2];
    reg [1:0] ptr;

    always @(posedge clk) begin
        if (reset) begin
            ptr <= 2'b00;
            done <= 1'b0;
            buffer[0] <= 8'b0;
            buffer[1] <= 8'b0;
            buffer[2] <= 8'b0;
        end else begin
            // Store incoming byte
            buffer[ptr] <= in;
            
            // Check for complete message (current ptr points to 3rd byte)
            done <= (ptr == 2'b10) && buffer[0][3];
            
            // Update pointer (0->1->2->0...)
            ptr <= (ptr == 2'b10) ? 2'b00 : ptr + 1'b1;
        end
    end

endmodule
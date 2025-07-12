module TopModule (
    input [2:0] in,
    output reg [1:0] out,
    input clk,
    input reset
);
    reg [1:0] count;
    reg [1:0] bit_pos;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 2'b0;
            bit_pos <= 2'b0;
            out <= 2'b0;
        end else begin
            if (bit_pos < 2'b11) begin
                // Accumulate population count
                count <= count + in[bit_pos];
                bit_pos <= bit_pos + 1;
            end else begin
                // Output final result and reset
                out <= count;
                count <= 2'b0;
                bit_pos <= 2'b0;
            end
        end
    end
endmodule
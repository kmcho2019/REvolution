module TopModule(
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;

    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
        end else begin
            for (int i = 0; i < 32; i++) begin
                if (~in[i] && prev_in[i]) begin
                    out[i] <= 1'b1;
                end 
            end
            prev_in <= in;
        end
    end

endmodule
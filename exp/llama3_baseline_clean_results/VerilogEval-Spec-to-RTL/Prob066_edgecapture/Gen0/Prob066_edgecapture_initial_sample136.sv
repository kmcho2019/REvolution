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
            prev_in <= 32'b0;
        end else begin
            prev_in <= in;
            for (int i = 0; i < 32; i++) begin
                if (in[i] == 1'b0 && prev_in[i] == 1'b1) begin
                    out[i] <= 1'b1;
                end else if (out[i] == 1'b1) begin
                    out[i] <= 1'b1; // hold the value
                end else begin
                    out[i] <= 1'b0; // initialize or clear the value
                end
            end
        end
    end

endmodule
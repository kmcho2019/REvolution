module TopModule(
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;
    reg [31:0] flag;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            flag <= 32'b0;
        end else begin
            prev_in <= in;
            for (int i = 0; i < 32; i++) begin
                if (in[i] == 1'b0 && prev_in[i] == 1'b1) begin
                    flag[i] <= 1'b1;
                end
            end
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
        end else begin
            out <= flag;
        end
    end

endmodule
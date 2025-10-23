module TopModule (
    input wire clk,
    input wire reset,
    input wire [31:0] in,
    output reg [31:0] out
);

    reg [31:0] reg_in;
    reg [31:0] prev_reg_in;

    always @(posedge clk) begin
        if (reset) begin
            reg_in <= 32'b0;
            prev_reg_in <= 32'b0;
            out <= 32'b0;
        end else begin
            prev_reg_in <= reg_in;
            reg_in <= in;
            // Falling edge detected when previous bit is 1 and current bit is 0
            out <= out | (prev_reg_in & ~reg_in);
        end
    end

endmodule
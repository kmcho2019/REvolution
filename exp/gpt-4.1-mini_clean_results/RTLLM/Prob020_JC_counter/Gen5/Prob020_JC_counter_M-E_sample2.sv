module JC_counter (
    input wire clk,
    input wire rst_n,
    output reg [63:0] Q
);

reg [31:0] upper, lower;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        upper <= 32'b0;
        lower <= 32'b0;
        Q <= 64'b0;
    end else begin
        // Capture inverted LSBs to insert
        wire upper_in_bit = ~lower[0];
        wire lower_in_bit = ~upper[0];

        upper <= {upper_in_bit, upper[31:1]};
        lower <= {lower_in_bit, lower[31:1]};

        Q <= {upper, lower};
    end
end

endmodule
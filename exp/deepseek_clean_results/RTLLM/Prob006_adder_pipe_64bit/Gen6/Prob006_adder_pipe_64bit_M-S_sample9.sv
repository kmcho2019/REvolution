module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Combinational addition
wire [64:0] sum = {1'b0, adda} + {1'b0, addb};

// Single pipeline stage for result and enable
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        result <= sum;
        o_en <= i_en;
    end
end

endmodule
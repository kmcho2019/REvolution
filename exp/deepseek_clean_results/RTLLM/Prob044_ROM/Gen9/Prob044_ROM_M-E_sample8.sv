module ROM #(
    parameter WIDTH = 16,
    parameter DEPTH = 256,
    parameter [WIDTH-1:0] DEFAULT = 16'h0000,
    parameter REGISTERED = 0
) (
    input [7:0] addr,
    output reg [WIDTH-1:0] dout
);

    // Define specific memory values as parameters
    parameter [WIDTH-1:0] VAL_0 = 16'hA0A0;
    parameter [WIDTH-1:0] VAL_1 = 16'hB1B1;
    parameter [WIDTH-1:0] VAL_2 = 16'hC2C2;
    parameter [WIDTH-1:0] VAL_3 = 16'hD3D3;

    // Internal combinational output
    wire [WIDTH-1:0] dout_comb;

    // ROM implementation using case statement
    always @(*) begin
        case (addr)
            8'd0: dout_comb = VAL_0;
            8'd1: dout_comb = VAL_1;
            8'd2: dout_comb = VAL_2;
            8'd3: dout_comb = VAL_3;
            default: dout_comb = DEFAULT;
        endcase
    end

    // Optional output register
    generate
        if (REGISTERED) begin
            always @(posedge clk) begin
                dout <= dout_comb;
            end
        end else begin
            always @(*) begin
                dout = dout_comb;
            end
        end
    endgenerate

endmodule
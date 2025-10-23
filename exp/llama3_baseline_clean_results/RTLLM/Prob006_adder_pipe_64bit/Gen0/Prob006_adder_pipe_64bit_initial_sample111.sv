module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

reg [63:0] adda_reg1;
reg [63:0] addb_reg1;
reg i_en_reg1;

reg [63:0] adda_reg2;
reg [63:0] addb_reg2;
reg i_en_reg2;

reg [64:0] sum;

wire [63:0] carry;

assign carry[0] = 0;

genvar i;
generate
    for (i = 0; i < 64; i++) begin
        full_adder fa(
            .a(adda_reg2[i]),
            .b(addb_reg2[i]),
            .cin(carry[i]),
            .s(sum[i]),
            .cout(carry[i+1])
        );
    end
endgenerate

assign result = sum;
assign o_en = i_en_reg2;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg1 <= 64'd0;
        addb_reg1 <= 64'd0;
        i_en_reg1 <= 1'b0;
        
        adda_reg2 <= 64'd0;
        addb_reg2 <= 64'd0;
        i_en_reg2 <= 1'b0;
        
        sum <= 65'd0;
    end else if (i_en) begin
        adda_reg1 <= adda;
        addb_reg1 <= addb;
        i_en_reg1 <= i_en;
        
        adda_reg2 <= adda_reg1;
        addb_reg2 <= addb_reg1;
        i_en_reg2 <= i_en_reg1;
        
        sum <= {1'b0, adda_reg2} + {1'b0, addb_reg2} + {64'd0, carry[63]};
    end else begin
        adda_reg1 <= adda_reg1;
        addb_reg1 <= addb_reg1;
        i_en_reg1 <= i_en_reg1;
        
        adda_reg2 <= adda_reg2;
        addb_reg2 <= addb_reg2;
        i_en_reg2 <= i_en_reg2;
        
        sum <= sum;
    end
end

// 1-bit full adder module
module full_adder(
    input a,
    input b,
    input cin,
    output s,
    output cout
);

assign s = a ^ b ^ cin;
assign cout = (a & b) | (a & cin) | (b & cin);

endmodule

endmodule
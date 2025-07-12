// Full Adder Module
module full_adder(a, b, cin, sum, cout);
    input a, b, cin;
    output sum, cout;

    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// 64-bit Ripple Carry Adder Module
module adder_pipe_64bit(clk, rst_n, i_en, adda, addb, result, o_en);
    input clk, rst_n, i_en;
    input [63:0] adda, addb;
    output [64:0] result;
    output o_en;

    reg [63:0] reg_adda, reg_addb;
    reg [64:0] sum;
    reg o_en_reg;

    // Pipeline Stage 1: Synchronize input enable signal and input operands
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_adda <= 64'd0;
            reg_addb <= 64'd0;
        end else if (i_en) begin
            reg_adda <= adda;
            reg_addb <= addb;
        end
    end

    // Pipeline Stage 2: Perform addition
    reg [64:0] sum_reg;
    wire [63:0] sum_wire;
    wire cout;
    genvar i;
    generate
        for (i = 0; i < 64; i++) begin: gen_adder
            wire cin;
            if (i == 0) begin
                assign cin = 1'b0;
            end else begin
                assign cin = sum_reg[i-1];
            end
            full_adder u_full_adder(.a(reg_adda[i]), .b(reg_addb[i]), .cin(cin), .sum(sum_wire[i]), .cout(sum_reg[i]));
        end
    endgenerate
    assign sum_wire[63] = sum_reg[63];
    assign result = {sum_reg[63], sum_wire};

    // Pipeline Stage 3: Update output enable signal
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            o_en_reg <= 1'b0;
        end else if (i_en) begin
            o_en_reg <= 1'b1;
        end else begin
            o_en_reg <= 1'b0;
        end
    end

    assign o_en = o_en_reg;

endmodule
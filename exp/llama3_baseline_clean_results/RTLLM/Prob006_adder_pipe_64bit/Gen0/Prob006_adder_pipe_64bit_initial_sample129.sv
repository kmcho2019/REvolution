// 1-bit full adder module
module full_adder(
    input  logic a,
    input  logic b,
    input  logic cin,
    output logic sum,
    output logic cout
);

    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);

endmodule

// 64-bit ripple carry adder module
module adder_pipe_64bit(
    input  logic         clk,
    input  logic         rst_n,
    input  logic         i_en,
    input  logic [63:0]  adda,
    input  logic [63:0]  addb,
    output logic [64:0]  result,
    output logic         o_en
);

    // pipeline registers
    logic [63:0]  reg_adda [2:0];
    logic [63:0]  reg_addb [2:0];
    logic         reg_i_en [2:0];

    // initialize pipeline registers
    always_ff @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            reg_adda[0] <= '0;
            reg_addb[0] <= '0;
            reg_i_en[0] <= '0;
            reg_adda[1] <= '0;
            reg_addb[1] <= '0;
            reg_i_en[1] <= '0;
            reg_adda[2] <= '0;
            reg_addb[2] <= '0;
            reg_i_en[2] <= '0;
        end else if (i_en) begin
            reg_adda[0] <= adda;
            reg_addb[0] <= addb;
            reg_i_en[0] <= i_en;
        end else begin
            reg_adda[0] <= reg_adda[0];
            reg_addb[0] <= reg_addb[0];
            reg_i_en[0] <= reg_i_en[0];
        end

        if (~rst_n) begin
            reg_adda[1] <= '0;
            reg_addb[1] <= '0;
            reg_i_en[1] <= '0;
        end else begin
            reg_adda[1] <= reg_adda[0];
            reg_addb[1] <= reg_addb[0];
            reg_i_en[1] <= reg_i_en[0];
        end

        if (~rst_n) begin
            reg_adda[2] <= '0;
            reg_addb[2] <= '0;
            reg_i_en[2] <= '0;
        end else begin
            reg_adda[2] <= reg_adda[1];
            reg_addb[2] <= reg_addb[1];
            reg_i_en[2] <= reg_i_en[1];
        end
    end

    // calculate sum
    logic [63:0] sum;
    logic [63:0] carry;

    always_comb begin
        sum = '0;
        carry = '0;
        for (int i = 0; i < 64; i++) begin
            logic cout;
            full_adder fa(
               .a(reg_adda[2][i]),
               .b(reg_addb[2][i]),
               .cin(i == 0? 1'b0 : carry[i-1]),
               .sum(sum[i]),
               .cout(cout)
            );
            if (i < 63) begin
                carry[i] = cout;
            end
        end
    end

    // assign output
    always_comb begin
        result = {carry[63], sum};
        o_en = reg_i_en[2];
    end

endmodule
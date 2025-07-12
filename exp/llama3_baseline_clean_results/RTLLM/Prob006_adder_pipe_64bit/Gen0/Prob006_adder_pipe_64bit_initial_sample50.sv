// 1-bit full adder module
module full_adder (
    input  logic       a,
    input  logic       b,
    input  logic       cin,
    output logic       sum,
    output logic       cout
);

    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);

endmodule

// 64-bit ripple carry adder with pipeline stages
module adder_pipe_64bit (
    input  logic                   clk,
    input  logic                   rst_n,
    input  logic                   i_en,
    input  logic [63:0]            adda,
    input  logic [63:0]            addb,
    output logic [64:0]            result,
    output logic                   o_en
);

    logic [63:0]            adda_reg1, adda_reg2, adda_reg3;
    logic [63:0]            addb_reg1, addb_reg2, addb_reg3;
    logic                   i_en_reg1, i_en_reg2, i_en_reg3;
    logic [63:0]            sum_reg1, sum_reg2, sum_reg3;
    logic                   cout_reg1, cout_reg2, cout_reg3;
    logic                   o_en_reg1, o_en_reg2;

    // Pipeline stage 1
    always_ff @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            adda_reg1 <= '0;
            addb_reg1 <= '0;
            i_en_reg1 <= '0;
        end else if (i_en) begin
            adda_reg1 <= adda;
            addb_reg1 <= addb;
            i_en_reg1 <= i_en;
        end
    end

    // Pipeline stage 2
    always_ff @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            adda_reg2 <= '0;
            addb_reg2 <= '0;
            i_en_reg2 <= '0;
            sum_reg1 <= '0;
            cout_reg1 <= '0;
        end else if (i_en_reg1) begin
            adda_reg2 <= adda_reg1;
            addb_reg2 <= addb_reg1;
            i_en_reg2 <= i_en_reg1;
            full_adder fa0 (.a(adda_reg1[0]), .b(addb_reg1[0]), .cin(1'b0), .sum(sum_reg1[0]), .cout(cout_reg1));
            for (genvar i = 1; i < 64; i++) begin
                full_adder fa (.a(adda_reg1[i]), .b(addb_reg1[i]), .cin(cout_reg1), .sum(sum_reg1[i]), .cout(cout_reg1));
                assign cout_reg1 = (adda_reg1[i] & addb_reg1[i]) | (adda_reg1[i] & cout_reg1) | (addb_reg1[i] & cout_reg1);
            end
        end
    end

    // Pipeline stage 3
    always_ff @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            adda_reg3 <= '0;
            addb_reg3 <= '0;
            i_en_reg3 <= '0;
            sum_reg2 <= '0;
            cout_reg2 <= '0;
            o_en_reg1 <= '0;
        end else if (i_en_reg2) begin
            adda_reg3 <= adda_reg2;
            addb_reg3 <= addb_reg2;
            i_en_reg3 <= i_en_reg2;
            sum_reg2 <= sum_reg1;
            cout_reg2 <= cout_reg1;
            o_en_reg1 <= i_en_reg2;
        end
    end

    // Pipeline stage 4
    always_ff @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            sum_reg3 <= '0;
            cout_reg3 <= '0;
            o_en_reg2 <= '0;
        end else if (i_en_reg3) begin
            sum_reg3 <= sum_reg2;
            cout_reg3 <= cout_reg2;
            o_en_reg2 <= o_en_reg1;
        end
    end

    assign result = {cout_reg3, sum_reg3};
    assign o_en = o_en_reg2;

endmodule
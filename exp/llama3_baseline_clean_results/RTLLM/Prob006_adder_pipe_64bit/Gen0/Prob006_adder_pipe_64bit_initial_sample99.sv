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

module adder_pipe_64bit(
    input  logic           clk,
    input  logic           rst_n,
    input  logic           i_en,
    input  logic [63:0]    adda,
    input  logic [63:0]    addb,
    output logic [64:0]    result,
    output logic           o_en
);

    logic [63:0]           adda_reg1, adda_reg2;
    logic [63:0]           addb_reg1, addb_reg2;
    logic                  i_en_reg1, i_en_reg2;
    logic [64:0]           sum_reg1, sum_reg2;
    logic                  cout_reg1, cout_reg2;
    logic                  o_en_reg1;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            adda_reg1 <= '0;
            addb_reg1 <= '0;
            i_en_reg1 <= 1'b0;
        end else begin
            adda_reg1 <= adda;
            addb_reg1 <= addb;
            i_en_reg1 <= i_en;
        end
    end

    logic [63:0]           sum1;
    logic                  cout1;

    full_adder fa0(
        .a(adda_reg1[0]),
        .b(addb_reg1[0]),
        .cin(1'b0),
        .sum(sum1[0]),
        .cout(cout1)
    );

    genvar i;
    generate
        for (i = 1; i < 64; i++) begin
            full_adder fa(
                .a(adda_reg1[i]),
                .b(addb_reg1[i]),
                .cin(cout1),
                .sum(sum1[i]),
                .cout(cout1)
            );
        end
    endgenerate

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_reg1 <= '0;
            cout_reg1 <= 1'b0;
            adda_reg2 <= '0;
            addb_reg2 <= '0;
            i_en_reg2 <= 1'b0;
        end else begin
            sum_reg1 <= {cout1, sum1};
            cout_reg1 <= cout1;
            adda_reg2 <= adda_reg1;
            addb_reg2 <= addb_reg1;
            i_en_reg2 <= i_en_reg1;
        end
    end

    logic [63:0]           sum2;
    logic                  cout2;

    full_adder fa2(
        .a(adda_reg2[0]),
        .b(addb_reg2[0]),
        .cin(1'b0),
        .sum(sum2[0]),
        .cout(cout2)
    );

    generate
        for (i = 1; i < 64; i++) begin
            full_adder fa3(
                .a(adda_reg2[i]),
                .b(addb_reg2[i]),
                .cin(cout2),
                .sum(sum2[i]),
                .cout(cout2)
            );
        end
    endgenerate

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_reg2 <= '0;
            cout_reg2 <= 1'b0;
            o_en_reg1 <= 1'b0;
        end else begin
            sum_reg2 <= {cout2, sum2};
            cout_reg2 <= cout2;
            o_en_reg1 <= i_en_reg2;
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= '0;
            o_en <= 1'b0;
        end else begin
            result <= sum_reg2;
            o_en <= o_en_reg1;
        end
    end

endmodule
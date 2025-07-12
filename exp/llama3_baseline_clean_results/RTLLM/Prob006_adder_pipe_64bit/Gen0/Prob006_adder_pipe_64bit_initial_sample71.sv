// One-bit full adder module
module full_adder(
    input   logic       a,
    input   logic       b,
    input   logic       cin,
    output  logic       sum,
    output  logic       cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// 64-bit ripple carry adder with pipeline stages
module adder_pipe_64bit(
    input   logic               clk,
    input   logic               rst_n,
    input   logic               i_en,
    input   logic   [63:0]      adda,
    input   logic   [63:0]      addb,
    output  logic   [64:0]      result,
    output  logic               o_en
);

// Input registers for operands A and B, and enable signal
logic   [63:0]      reg_adda;
logic   [63:0]      reg_addb;
logic               reg_i_en;

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_adda  <= '0;
        reg_addb  <= '0;
        reg_i_en  <= '0;
    end else if (i_en) begin
        reg_adda  <= adda;
        reg_addb  <= addb;
        reg_i_en  <= i_en;
    end
end

// One-bit full adder instances
logic   [63:0]      sums;
logic   [63:0]      carries;
logic               cout;

// First stage: calculate sums and carries
always_comb begin
    sums[0] = reg_adda[0] ^ reg_addb[0];
    carries[0] = reg_adda[0] & reg_addb[0];
    for (int i = 1; i < 64; i++) begin
        sums[i] = reg_adda[i] ^ reg_addb[i] ^ carries[i-1];
        carries[i] = (reg_adda[i] & reg_addb[i]) | (reg_adda[i] & carries[i-1]) | (reg_addb[i] & carries[i-1]);
    end
    cout = carries[63];
end

// Register the sums and carry
logic   [63:0]      reg_sums;
logic               reg_cout;

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_sums  <= '0;
        reg_cout  <= '0;
    end else begin
        reg_sums  <= sums;
        reg_cout  <= cout;
    end
end

// Output registers for result and output enable signal
always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        result  <= '0;
        o_en    <= '0;
    end else if (reg_i_en) begin
        result  <= {reg_cout, reg_sums};
        o_en    <= reg_i_en;
    end else begin
        result  <= '0;
        o_en    <= '0;
    end
end

endmodule
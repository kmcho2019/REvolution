// 1-bit full adder module
module full_adder (
    input  wire    a,
    input  wire    b,
    input  wire    cin,
    output wire    sum,
    output wire    cout
);

    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);

endmodule

// 64-bit ripple carry adder with pipeline stages
module adder_pipe_64bit (
    input  wire            clk,
    input  wire            rst_n,
    input  wire            i_en,
    input  wire    [63:0]  adda,
    input  wire    [63:0]  addb,
    output wire    [64:0]  result,
    output wire            o_en
);

    // registers to synchronize input enable signal
    reg     [0:0]           en_pipe1;
    reg     [0:0]           en_pipe2;
    reg     [0:0]           en_pipe3;

    // registers to store input operands
    reg     [63:0]          adda_pipe1;
    reg     [63:0]          addb_pipe1;
    reg     [63:0]          adda_pipe2;
    reg     [63:0]          addb_pipe2;

    // registers to store sum values
    reg     [64:0]          sum_pipe1;
    reg     [64:0]          sum_pipe2;

    // internal signals
    wire    [63:0]          sum_bits;
    wire                    cout;

    // 64-bit ripple carry adder
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin
            full_adder fa (
                .a(adda_pipe2[i]),
                .b(addb_pipe2[i]),
                .cin(i == 0 ? 1'b0 : sum_pipe2[i-1][64]),
                .sum(sum_bits[i]),
                .cout(cout)
            );
        end
    endgenerate

    // output result
    assign result = {cout, sum_bits};

    // update output enable signal
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            en_pipe1 <= 1'b0;
            en_pipe2 <= 1'b0;
            en_pipe3 <= 1'b0;
            o_en <= 1'b0;
        end else begin
            en_pipe1 <= i_en;
            en_pipe2 <= en_pipe1;
            en_pipe3 <= en_pipe2;
            o_en <= en_pipe3;
        end
    end

    // update registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            adda_pipe1 <= 64'b0;
            addb_pipe1 <= 64'b0;
            adda_pipe2 <= 64'b0;
            addb_pipe2 <= 64'b0;
            sum_pipe1 <= 65'b0;
            sum_pipe2 <= 65'b0;
        end else begin
            if (en_pipe1) begin
                adda_pipe1 <= adda;
                addb_pipe1 <= addb;
            end
            if (en_pipe2) begin
                adda_pipe2 <= adda_pipe1;
                addb_pipe2 <= addb_pipe1;
                sum_pipe1 <= {1'b0, adda_pipe1} + {1'b0, addb_pipe1};
            end
            if (en_pipe3) begin
                sum_pipe2 <= sum_pipe1;
            end
        end
    end

endmodule
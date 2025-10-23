// 1-bit full adder module
module full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);

    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);

endmodule

// 64-bit ripple carry adder module
module adder_pipe_64bit (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        i_en,
    input  wire [63:0] adda,
    input  wire [63:0] addb,
    output reg  [64:0] result,
    output reg         o_en
);

    // pipeline stage 1: input registers
    reg [63:0] adda_reg1;
    reg [63:0] addb_reg1;
    reg        i_en_reg1;

    // pipeline stage 2: 64-bit ripple carry adder
    wire [63:0] sum;
    wire [63:0] cout;
    reg  [63:0] sum_reg2;
    reg         cout_reg2;
    reg         i_en_reg2;

    // pipeline stage 3: output registers
    reg [64:0] result_reg3;
    reg         o_en_reg3;

    // instantiate 1-bit full adder modules
    genvar i;
    generate
        for (i = 0; i < 64; i++) begin
            full_adder fa (
                .a    (adda_reg1[i]),
                .b    (addb_reg1[i]),
                .cin  (i == 0 ? 1'b0 : cout[i-1]),
                .sum  (sum[i]),
                .cout (cout[i])
            );
        end
    endgenerate

    // assign sum and cout to registers
    always @(*) begin
        sum_reg2 = sum;
        cout_reg2 = cout[63];
    end

    // assign result to output port
    always @(*) begin
        result = {cout_reg2, sum_reg2};
    end

    // clocked always block
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            // reset values
            adda_reg1 <= 64'd0;
            addb_reg1 <= 64'd0;
            i_en_reg1 <= 1'b0;
            sum_reg2 <= 64'd0;
            cout_reg2 <= 1'b0;
            i_en_reg2 <= 1'b0;
            result_reg3 <= 65'd0;
            o_en_reg3 <= 1'b0;
            result <= 65'd0;
            o_en <= 1'b0;
        end else begin
            // pipeline stage 1: input registers
            adda_reg1 <= adda;
            addb_reg1 <= addb;
            i_en_reg1 <= i_en;

            // pipeline stage 2: 64-bit ripple carry adder
            i_en_reg2 <= i_en_reg1;

            // pipeline stage 3: output registers
            result_reg3 <= {cout_reg2, sum_reg2};
            o_en_reg3 <= i_en_reg2;

            // assign output ports
            result <= result_reg3;
            o_en <= o_en_reg3;
        end
    end

endmodule
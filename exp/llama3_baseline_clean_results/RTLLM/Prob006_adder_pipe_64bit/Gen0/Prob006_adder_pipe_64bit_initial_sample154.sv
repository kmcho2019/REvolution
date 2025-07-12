// 1-bit full adder module
module full_adder(a, b, cin, sum, cout);
    input  a, b, cin;
    output sum, cout;

    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// 64-bit ripple carry adder with pipeline stages
module adder_pipe_64bit(clk, rst_n, i_en, adda, addb, result, o_en);
    input  clk, rst_n, i_en;
    input  [63:0] adda, addb;
    output [64:0] result;
    output       o_en;

    reg [63:0] adda_reg, addb_reg;
    reg [64:0] sum_reg;
    reg        i_en_reg, o_en_reg;
    reg [63:0] cout_reg;

    integer i;

    // Synchronize input enable signal
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i_en_reg <= 1'b0;
        end else begin
            i_en_reg <= i_en;
        end
    end

    // Register input operands
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            adda_reg <= 64'd0;
            addb_reg <= 64'd0;
        end else if (i_en_reg) begin
            adda_reg <= adda;
            addb_reg <= addb;
        end
    end

    // Perform addition
    wire [63:0] cout;
    assign cout[0] = 1'b0;
    wire [63:0] sum;
    generate
        for (i = 0; i < 64; i++) begin
            wire sum_w, cout_w;
            full_adder fa(adda_reg[i], addb_reg[i], cout[i], sum_w, cout_w);
            assign sum[i] = sum_w;
            assign cout[i+1] = cout_w;
        end
    endgenerate

    // Register sum
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_reg <= 65'd0;
        end else if (i_en_reg) begin
            sum_reg <= {cout[63], sum};
        end
    end

    // Generate output enable signal
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            o_en_reg <= 1'b0;
        end else if (i_en_reg) begin
            o_en_reg <= 1'b1;
        end else begin
            o_en_reg <= 1'b0;
        end
    end

    // Assign output
    assign result = sum_reg;
    assign o_en = o_en_reg;

endmodule
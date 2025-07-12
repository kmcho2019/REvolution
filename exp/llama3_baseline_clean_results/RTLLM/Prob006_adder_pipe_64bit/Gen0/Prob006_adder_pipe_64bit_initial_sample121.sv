module full_adder(a, b, cin, s, cout);
    input a, b, cin;
    output s, cout;

    assign s = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

module adder_pipe_64bit(clk, rst_n, i_en, adda, addb, result, o_en);
    input clk, rst_n, i_en;
    input [63:0] adda, addb;
    output [64:0] result;
    output o_en;

    reg [63:0] adda_pipe1, addb_pipe1;
    reg [63:0] adda_pipe2, addb_pipe2;
    reg i_en_pipe1, i_en_pipe2;
    reg [64:0] sum;

    // Pipeline stage 1
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            adda_pipe1 <= 64'd0;
            addb_pipe1 <= 64'd0;
            i_en_pipe1 <= 1'd0;
        end else if (i_en) begin
            adda_pipe1 <= adda;
            addb_pipe1 <= addb;
            i_en_pipe1 <= 1'd1;
        end else begin
            adda_pipe1 <= adda_pipe1;
            addb_pipe1 <= addb_pipe1;
            i_en_pipe1 <= i_en_pipe1;
        end
    end

    // Pipeline stage 2
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            adda_pipe2 <= 64'd0;
            addb_pipe2 <= 64'd0;
            i_en_pipe2 <= 1'd0;
        end else begin
            adda_pipe2 <= adda_pipe1;
            addb_pipe2 <= addb_pipe1;
            i_en_pipe2 <= i_en_pipe1;
        end
    end

    // Ripple carry adder
    wire [63:0] carry;
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin
            wire s, cout;
            full_adder u_full_adder(.a(adda_pipe2[i]), .b(addb_pipe2[i]), .cin(i == 0 ? 1'd0 : carry[i - 1]), .s(sum[i]), .cout(cout));
            if (i < 63) begin
                assign carry[i] = cout;
            end
        end
    endgenerate
    assign sum[64] = carry[63];

    // Output enable signal
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            o_en <= 1'd0;
        end else if (i_en_pipe2) begin
            o_en <= 1'd1;
        end else begin
            o_en <= 1'd0;
        end
    end

    assign result = sum;

endmodule
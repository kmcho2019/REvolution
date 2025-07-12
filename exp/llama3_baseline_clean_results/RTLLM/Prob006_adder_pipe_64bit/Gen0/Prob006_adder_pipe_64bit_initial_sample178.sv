module adder_pipe_64bit(
    input clk, 
    input rst_n, 
    input i_en, 
    input [63:0] adda, 
    input [63:0] addb, 
    output [64:0] result, 
    output o_en
);

    reg [63:0] adda_pipe1;
    reg [63:0] addb_pipe1;
    reg i_en_pipe1;

    reg [63:0] adda_pipe2;
    reg [63:0] addb_pipe2;
    reg [64:0] result_pipe2;
    reg i_en_pipe2;

    reg [63:0] adda_pipe3;
    reg [63:0] addb_pipe3;
    reg [64:0] result_pipe3;
    reg i_en_pipe3;

    reg [63:0] adda_pipe4;
    reg [63:0] addb_pipe4;
    reg [64:0] result_pipe4;
    reg o_en_pipe4;

    assign result = result_pipe4;
    assign o_en = o_en_pipe4;

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
            i_en_pipe1 <= 1'd0;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            adda_pipe2 <= 64'd0;
            addb_pipe2 <= 64'd0;
            result_pipe2 <= 65'd0;
            i_en_pipe2 <= 1'd0;
        end else begin
            adda_pipe2 <= adda_pipe1;
            addb_pipe2 <= addb_pipe1;
            result_pipe2 <= adda_pipe1 + addb_pipe1;
            i_en_pipe2 <= i_en_pipe1;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            adda_pipe3 <= 64'd0;
            addb_pipe3 <= 64'd0;
            result_pipe3 <= 65'd0;
            i_en_pipe3 <= 1'd0;
        end else begin
            adda_pipe3 <= adda_pipe2;
            addb_pipe3 <= addb_pipe2;
            result_pipe3 <= result_pipe2;
            i_en_pipe3 <= i_en_pipe2;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            adda_pipe4 <= 64'd0;
            addb_pipe4 <= 64'd0;
            result_pipe4 <= 65'd0;
            o_en_pipe4 <= 1'd0;
        end else begin
            adda_pipe4 <= adda_pipe3;
            addb_pipe4 <= addb_pipe3;
            result_pipe4 <= result_pipe3;
            o_en_pipe4 <= i_en_pipe3;
        end
    end

endmodule
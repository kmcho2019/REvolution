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
reg [63:0] adda_pipe2;
reg [63:0] addb_pipe2;
reg [63:0] sum_pipe2;
reg [64:0] sum_pipe3;
reg i_en_pipe1;
reg i_en_pipe2;

// synchronize input enable signal with clock and reset
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        i_en_pipe1 <= 1'b0;
        i_en_pipe2 <= 1'b0;
    end else begin
        i_en_pipe1 <= i_en;
        i_en_pipe2 <= i_en_pipe1;
    end
end

// stage 1: input registers
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_pipe1 <= 64'd0;
        addb_pipe1 <= 64'd0;
    end else if (i_en) begin
        adda_pipe1 <= adda;
        addb_pipe1 <= addb;
    end
end

// stage 2: adder and registers
reg [63:0] sum;
reg cout;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum <= 64'd0;
        cout <= 1'b0;
        adda_pipe2 <= 64'd0;
        addb_pipe2 <= 64'd0;
    end else if (i_en_pipe1) begin
        adda_pipe2 <= adda_pipe1;
        addb_pipe2 <= addb_pipe1;
        sum <= adda_pipe1 + addb_pipe1;
        cout <= (adda_pipe1[63] & addb_pipe1[63]) | ((adda_pipe1[63] | addb_pipe1[63]) & sum[63]);
    end
end

// stage 3: final adder and registers
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum_pipe2 <= 64'd0;
        sum_pipe3 <= 65'd0;
    end else if (i_en_pipe2) begin
        sum_pipe2 <= sum;
        sum_pipe3 <= {cout, sum};
    end
end

// output logic
assign result = sum_pipe3;
assign o_en = i_en_pipe2;

endmodule
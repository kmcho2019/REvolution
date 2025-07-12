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
reg i_en_pipe2;
reg [64:0] result_pipe2;

// Pipeline stage 1
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_pipe1 <= 0;
        addb_pipe1 <= 0;
        i_en_pipe1 <= 0;
    end else if (i_en) begin
        adda_pipe1 <= adda;
        addb_pipe1 <= addb;
        i_en_pipe1 <= 1;
    end else begin
        adda_pipe1 <= adda_pipe1;
        addb_pipe1 <= addb_pipe1;
        i_en_pipe1 <= 0;
    end
end

// Pipeline stage 2
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_pipe2 <= 0;
        addb_pipe2 <= 0;
        i_en_pipe2 <= 0;
    end else begin
        adda_pipe2 <= adda_pipe1;
        addb_pipe2 <= addb_pipe1;
        i_en_pipe2 <= i_en_pipe1;
    end
end

// Calculate result
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result_pipe2 <= 0;
    end else if (i_en_pipe2) begin
        reg [63:0] temp_adda;
        reg [63:0] temp_addb;
        reg [63:0] temp_result;
        reg carry;

        temp_adda = adda_pipe2;
        temp_addb = addb_pipe2;
        temp_result = 0;
        carry = 0;

        for (int i = 0; i < 64; i++) begin
            temp_result[i] = temp_adda[i] ^ temp_addb[i] ^ carry;
            carry = (temp_adda[i] & temp_addb[i]) | (temp_adda[i] & carry) | (temp_addb[i] & carry);
        end

        result_pipe2[63:0] = temp_result;
        result_pipe2[64] = carry;
    end else begin
        result_pipe2 <= 0;
    end
end

// Output
assign result = result_pipe2;
assign o_en = i_en_pipe2;

endmodule
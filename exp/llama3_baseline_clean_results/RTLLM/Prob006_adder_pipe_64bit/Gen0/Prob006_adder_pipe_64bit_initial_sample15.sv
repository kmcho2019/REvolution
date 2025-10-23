module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

reg [63:0] adda_pipe [3:0];
reg [63:0] addb_pipe [3:0];
reg [64:0] sum_pipe [3:0];
reg [0:0] i_en_pipe [3:0];
reg [0:0] o_en_pipe [3:0];

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_pipe[0] <= 64'd0;
        addb_pipe[0] <= 64'd0;
        sum_pipe[0] <= 65'd0;
        i_en_pipe[0] <= 1'd0;
        o_en_pipe[0] <= 1'd0;
        adda_pipe[1] <= 64'd0;
        addb_pipe[1] <= 64'd0;
        sum_pipe[1] <= 65'd0;
        i_en_pipe[1] <= 1'd0;
        o_en_pipe[1] <= 1'd0;
        adda_pipe[2] <= 64'd0;
        addb_pipe[2] <= 64'd0;
        sum_pipe[2] <= 65'd0;
        i_en_pipe[2] <= 1'd0;
        o_en_pipe[2] <= 1'd0;
        adda_pipe[3] <= 64'd0;
        addb_pipe[3] <= 64'd0;
        sum_pipe[3] <= 65'd0;
        i_en_pipe[3] <= 1'd0;
        o_en_pipe[3] <= 1'd0;
    end else begin
        // pipeline stage 0
        if (i_en) begin
            adda_pipe[0] <= adda;
            addb_pipe[0] <= addb;
            i_en_pipe[0] <= 1'd1;
        end else begin
            adda_pipe[0] <= adda_pipe[0];
            addb_pipe[0] <= addb_pipe[0];
            i_en_pipe[0] <= i_en_pipe[0];
        end
        
        // pipeline stage 1
        adda_pipe[1] <= adda_pipe[0];
        addb_pipe[1] <= addb_pipe[0];
        i_en_pipe[1] <= i_en_pipe[0];
        
        // pipeline stage 2
        adda_pipe[2] <= adda_pipe[1];
        addb_pipe[2] <= addb_pipe[1];
        i_en_pipe[2] <= i_en_pipe[1];
        
        // pipeline stage 3
        adda_pipe[3] <= adda_pipe[2];
        addb_pipe[3] <= addb_pipe[2];
        i_en_pipe[3] <= i_en_pipe[2];
        
        // calculate sum
        sum_pipe[0] <= {1'd0, adda_pipe[3]} + {1'd0, addb_pipe[3]};
        
        // update o_en
        o_en_pipe[0] <= i_en_pipe[3];
        
        // update output
        result <= sum_pipe[0];
        o_en <= o_en_pipe[0];
    end
end

endmodule
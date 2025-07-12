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
reg i_en_pipe [3:0];
reg o_en_pipe;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (int i = 0; i <= 3; i++) begin
            adda_pipe[i] <= 64'd0;
            addb_pipe[i] <= 64'd0;
            sum_pipe[i] <= 65'd0;
            i_en_pipe[i] <= 1'b0;
        end
        o_en_pipe <= 1'b0;
    end else begin
        // Pipeline stage 0
        adda_pipe[0] <= adda;
        addb_pipe[0] <= addb;
        i_en_pipe[0] <= i_en;
        
        // Pipeline stage 1
        adda_pipe[1] <= adda_pipe[0];
        addb_pipe[1] <= addb_pipe[0];
        sum_pipe[0] <= {1'b0, adda_pipe[0][0]} + {1'b0, addb_pipe[0][0]};
        i_en_pipe[1] <= i_en_pipe[0];
        
        // Pipeline stage 2
        adda_pipe[2] <= adda_pipe[1];
        addb_pipe[2] <= addb_pipe[1];
        sum_pipe[1] <= {sum_pipe[0][64], sum_pipe[0][63:1]} + {1'b0, adda_pipe[1][1]} + {1'b0, addb_pipe[1][1]};
        i_en_pipe[2] <= i_en_pipe[1];
        
        // Pipeline stage 3
        adda_pipe[3] <= adda_pipe[2];
        addb_pipe[3] <= addb_pipe[2];
        sum_pipe[2] <= {sum_pipe[1][64], sum_pipe[1][63:1]} + {1'b0, adda_pipe[2][2]} + {1'b0, addb_pipe[2][2]};
        i_en_pipe[3] <= i_en_pipe[2];
        
        // Final stage
        sum_pipe[3] <= {sum_pipe[2][64], sum_pipe[2][63:1]} + {1'b0, adda_pipe[3][3]} + {1'b0, addb_pipe[3][3]};
        o_en_pipe <= i_en_pipe[3];
        
        result <= sum_pipe[3];
        o_en <= o_en_pipe;
    end
end

endmodule
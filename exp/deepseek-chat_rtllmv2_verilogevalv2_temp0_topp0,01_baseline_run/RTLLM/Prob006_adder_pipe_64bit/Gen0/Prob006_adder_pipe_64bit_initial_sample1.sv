module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

    // Pipeline stage 1 (bits 15:0)
    reg [15:0] adda_1, addb_1;
    reg [16:0] sum_1;
    reg en_1;

    // Pipeline stage 2 (bits 31:16)
    reg [15:0] adda_2, addb_2;
    reg [16:0] sum_2;
    reg en_2;

    // Pipeline stage 3 (bits 47:32)
    reg [15:0] adda_3, addb_3;
    reg [16:0] sum_3;
    reg en_3;

    // Pipeline stage 4 (bits 63:48)
    reg [15:0] adda_4, addb_4;
    reg [16:0] sum_4;
    reg en_4;

    // Final result computation
    reg [64:0] result_next;
    reg o_en_next;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers
            adda_1 <= 16'b0; addb_1 <= 16'b0; sum_1 <= 17'b0; en_1 <= 1'b0;
            adda_2 <= 16'b0; addb_2 <= 16'b0; sum_2 <= 17'b0; en_2 <= 1'b0;
            adda_3 <= 16'b0; addb_3 <= 16'b0; sum_3 <= 17'b0; en_3 <= 1'b0;
            adda_4 <= 16'b0; addb_4 <= 16'b0; sum_4 <= 17'b0; en_4 <= 1'b0;
            result <= 65'b0;
            o_en <= 1'b0;
        end else begin
            // Pipeline stage 1: process bits 15:0
            adda_1 <= adda[15:0];
            addb_1 <= addb[15:0];
            sum_1 <= {1'b0, adda[15:0]} + {1'b0, addb[15:0]};
            en_1 <= i_en;

            // Pipeline stage 2: process bits 31:16 with carry from stage 1
            adda_2 <= adda[31:16];
            addb_2 <= addb[31:16];
            sum_2 <= {1'b0, adda[31:16]} + {1'b0, addb[31:16]} + sum_1[16];
            en_2 <= en_1;

            // Pipeline stage 3: process bits 47:32 with carry from stage 2
            adda_3 <= adda[47:32];
            addb_3 <= addb[47:32];
            sum_3 <= {1'b0, adda[47:32]} + {1'b0, addb[47:32]} + sum_2[16];
            en_3 <= en_2;

            // Pipeline stage 4: process bits 63:48 with carry from stage 3
            adda_4 <= adda[63:48];
            addb_4 <= addb[63:48];
            sum_4 <= {1'b0, adda[63:48]} + {1'b0, addb[63:48]} + sum_3[16];
            en_4 <= en_3;

            // Final result assembly
            result <= {sum_4[15:0], sum_3[15:0], sum_2[15:0], sum_1[15:0]} + (sum_4[16] << 64);
            o_en <= en_4;
        end
    end

endmodule
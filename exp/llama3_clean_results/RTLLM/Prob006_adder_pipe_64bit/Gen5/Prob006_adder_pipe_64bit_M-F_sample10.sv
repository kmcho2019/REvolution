module adder_pipe_64bit(
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output  [64:0]  result,
    output          o_en
);

// Divide the 64-bit adder into four 16-bit segments for hierarchical addition
reg [15:0]  reg_adda_0, reg_adda_1, reg_adda_2, reg_adda_3;
reg [15:0]  reg_addb_0, reg_addb_1, reg_addb_2, reg_addb_3;
reg [16:0]  reg_result_0, reg_result_1, reg_result_2, reg_result_3;
reg         reg_carry_0, reg_carry_1, reg_carry_2;

// Conditional updates to reduce power consumption
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_adda_0 <= 16'd0; reg_adda_1 <= 16'd0; reg_adda_2 <= 16'd0; reg_adda_3 <= 16'd0;
        reg_addb_0 <= 16'd0; reg_addb_1 <= 16'd0; reg_addb_2 <= 16'd0; reg_addb_3 <= 16'd0;
        reg_result_0 <= 17'd0; reg_result_1 <= 17'd0; reg_result_2 <= 17'd0; reg_result_3 <= 17'd0;
        reg_carry_0 <= 1'b0; reg_carry_1 <= 1'b0; reg_carry_2 <= 1'b0;
    end else begin
        if (i_en) begin
            reg_adda_0 <= adda[15:0]; reg_adda_1 <= adda[31:16]; reg_adda_2 <= adda[47:32]; reg_adda_3 <= adda[63:48];
            reg_addb_0 <= addb[15:0]; reg_addb_1 <= addb[31:16]; reg_addb_2 <= addb[47:32]; reg_addb_3 <= addb[63:48];
        end
        
        // Hierarchical addition with carry propagation
        reg_result_0 <= {1'b0, reg_adda_0} + {1'b0, reg_addb_0};
        reg_carry_0 <= reg_result_0[16];
        reg_result_1 <= {1'b0, reg_adda_1} + {1'b0, reg_addb_1} + {16'{reg_carry_0}};
        reg_carry_1 <= reg_result_1[16];
        reg_result_2 <= {1'b0, reg_adda_2} + {1'b0, reg_addb_2} + {16'{reg_carry_1}};
        reg_carry_2 <= reg_result_2[16];
        reg_result_3 <= {1'b0, reg_adda_3} + {1'b0, reg_addb_3} + {16'{reg_carry_2}};
    end
end

// Assemble the final result from the hierarchical addition results
assign result = {reg_result_3[15:0], reg_result_2[15:0], reg_result_1[15:0], reg_result_0[15:0]};

// Output enable signal synchronization
reg reg_o_en;
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_o_en <= 1'b0;
    end else begin
        if (i_en) begin
            reg_o_en <= 1'b1;
        end else begin
            reg_o_en <= 1'b0;
        end
    end
end
assign o_en = reg_o_en;

endmodule
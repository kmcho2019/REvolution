module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Pipeline registers
reg [63:0] a_reg, b_reg;
reg [31:0] lower_sum;
reg lower_carry;

// Simple ripple-carry adder for lower 32 bits
wire [32:0] lower_result = {1'b0, adda[31:0]} + {1'b0, addb[31:0]};

// Pipeline control
reg [1:0] pipe_stage;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pipe_stage <= 2'b00;
        a_reg <= 64'b0;
        b_reg <= 64'b0;
        lower_sum <= 32'b0;
        lower_carry <= 1'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        case (pipe_stage)
            2'b00: begin  // Stage 0: Input capture
                if (i_en) begin
                    a_reg <= adda;
                    b_reg <= addb;
                    lower_sum <= lower_result[31:0];
                    lower_carry <= lower_result[32];
                    pipe_stage <= 2'b01;
                end
                o_en <= 1'b0;
            end
            
            2'b01: begin  // Stage 1: Upper bits addition
                // Ripple-carry for upper 32 bits
                result <= {1'b0, a_reg[63:32]} + {1'b0, b_reg[63:32]} + lower_carry;
                result[31:0] <= lower_sum;
                o_en <= 1'b1;
                pipe_stage <= 2'b00;
            end
        endcase
    end
end

endmodule
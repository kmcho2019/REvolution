module FlexiALU(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] r,
    output reg zero,
    output reg carry,
    output reg negative,
    output reg overflow,
    output reg flag
);

// Operation categories
parameter ARITHMETIC = 2'b00;
parameter LOGICAL = 2'b01;
parameter SHIFT = 2'b10;
parameter MISCELLANEOUS = 2'b11;

// Arithmetic operations
parameter ADD = 6'b100000;
parameter SUB = 6'b100010;
parameter ADDU = 6'b100001;
parameter SUBU = 6'b100011;

// Logical operations
parameter AND = 6'b100100;
parameter OR = 6'b100101;
parameter XOR = 6'b100110;
parameter NOR = 6'b100111;

// Shift operations
parameter SLL = 6'b000000;
parameter SRL = 6'b000010;
parameter SRA = 6'b000011;
parameter SLLV = 6'b000100;
parameter SRLV = 6'b000110;
parameter SRAV = 6'b000111;

// Miscellaneous operations
parameter SLT = 6'b101010;
parameter SLTU = 6'b101011;
parameter LUI = 6'b001111;

// Pipeline stages
parameter DECODE = 2'b00;
parameter FETCH = 2'b01;
parameter EXECUTE = 2'b10;
parameter PROCESS = 2'b11;

// Pipeline signals
reg [1:0] stage;
reg [31:0] pipeline_a;
reg [31:0] pipeline_b;
reg [5:0] pipeline_aluc;

// Operation fusion unit
wire [31:0] ofu_result;
wire ofu_flag;
operation_fusion_unit ofu(
   .a(a),
   .b(b),
   .aluc(aluc),
   .result(ofu_result),
   .flag(ofu_flag)
);

// Controller
always @(*) begin
    case (stage)
        DECODE: begin
            // Decode instruction
            pipeline_a = a;
            pipeline_b = b;
            pipeline_aluc = aluc;
            stage = FETCH;
        end
        FETCH: begin
            // Fetch operands
            stage = EXECUTE;
        end
        EXECUTE: begin
            // Execute operation
            case (pipeline_aluc[5:4])
                ARITHMETIC: begin
                    // Arithmetic operation
                    r = pipeline_a + pipeline_b;
                    carry = (pipeline_a[31]!= pipeline_b[31]) && (pipeline_a[31]!= r[31]);
                    overflow = (pipeline_a[31]!= pipeline_b[31]) && (pipeline_a[31]!= r[31]);
                end
                LOGICAL: begin
                    // Logical operation
                    case (pipeline_aluc[3:0])
                        AND: r = pipeline_a & pipeline_b;
                        OR: r = pipeline_a | pipeline_b;
                        XOR: r = pipeline_a ^ pipeline_b;
                        NOR: r = ~(pipeline_a | pipeline_b);
                    endcase
                end
                SHIFT: begin
                    // Shift operation
                    case (pipeline_aluc[3:0])
                        SLL: r = pipeline_a << pipeline_b[4:0];
                        SRL: r = pipeline_a >> pipeline_b[4:0];
                        SRA: r = pipeline_a >>> pipeline_b[4:0];
                    endcase
                end
                MISCELLANEOUS: begin
                    // Miscellaneous operation
                    case (pipeline_aluc[3:0])
                        SLT: begin
                            r = (signed'(pipeline_a) < signed'(pipeline_b))? 32'd1 : 32'd0;
                            flag = (signed'(pipeline_a) < signed'(pipeline_b));
                        end
                        SLTU: begin
                            r = (pipeline_a < pipeline_b)? 32'd1 : 32'd0;
                            flag = (pipeline_a < pipeline_b);
                        end
                        LUI: begin
                            r = {pipeline_a[15:0], 16'd0};
                            flag = 1'b0;
                        end
                    endcase
                end
            endcase
            stage = PROCESS;
        end
        PROCESS: begin
            // Process result
            zero = (r == 32'd0);
            negative = (r[31] == 1'b1);
            stage = DECODE;
        end
    endcase
end

// Operation fusion unit
module operation_fusion_unit(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] result,
    output reg flag
);

// Operation fusion logic
always @(*) begin
    case (aluc[5:4])
        ARITHMETIC: begin
            // Arithmetic operation fusion
            case (aluc[3:0])
                ADD: result = a + b;
                SUB: result = a - b;
            endcase
        end
        LOGICAL: begin
            // Logical operation fusion
            case (aluc[3:0])
                AND: result = a & b;
                OR: result = a | b;
            endcase
        end
        SHIFT: begin
            // Shift operation fusion
            case (aluc[3:0])
                SLL: result = a << b[4:0];
                SRL: result = a >> b[4:0];
            endcase
        end
        MISCELLANEOUS: begin
            // Miscellaneous operation fusion
            case (aluc[3:0])
                SLT: begin
                    result = (signed'(a) < signed'(b))? 32'd1 : 32'd0;
                    flag = (signed'(a) < signed'(b));
                end
                SLTU: begin
                    result = (a < b)? 32'd1 : 32'd0;
                    flag = (a < b);
                end
            endcase
        end
    endcase
end

endmodule
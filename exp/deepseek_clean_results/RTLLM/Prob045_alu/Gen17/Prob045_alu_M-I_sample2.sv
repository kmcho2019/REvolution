module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] r,
    output zero,
    output carry,
    output negative,
    output overflow,
    output reg flag
);

    // Operation codes
    parameter ADD  = 6'b100000;
    parameter ADDU = 6'b100001;
    parameter SUB  = 6'b100010;
    parameter SUBU = 6'b100011;
    parameter AND  = 6'b100100;
    parameter OR   = 6'b100101;
    parameter XOR  = 6'b100110;
    parameter NOR  = 6'b100111;
    parameter SLT  = 6'b101010;
    parameter SLTU = 6'b101011;
    parameter SLL  = 6'b000000;
    parameter SRL  = 6'b000010;
    parameter SRA  = 6'b000011;
    parameter SLLV = 6'b000100;
    parameter SRLV = 6'b000110;
    parameter SRAV = 6'b000111;
    parameter LUI  = 6'b001111;

    // Internal signals
    reg [31:0] result_bus;
    wire [32:0] add_result = a + b;
    wire [32:0] sub_result = a - b;
    wire [4:0] shift_amount = (aluc[3]) ? a[4:0] : b[4:0]; // SLLV/SRLV/SRAV use a[4:0]
    
    // Zero detection (combinational)
    assign zero = (result_bus == 32'b0);
    
    // Flag outputs
    assign carry = ((aluc == ADD || aluc == ADDU) && add_result[32]) ||
                  ((aluc == SUB || aluc == SUBU) && sub_result[32]);
    assign negative = result_bus[31];
    assign overflow = ((aluc == ADD) && (a[31] == b[31]) && (result_bus[31] != a[31])) ||
                     ((aluc == SUB) && (a[31] != b[31]) && (result_bus[31] != a[31]));

    // Main operation selection
    always @(*) begin
        case (aluc)
            ADD:  begin r = add_result[31:0]; flag = 1'b0; end
            ADDU: begin r = add_result[31:0]; flag = 1'b0; end
            SUB:  begin r = sub_result[31:0]; flag = 1'b0; end
            SUBU: begin r = sub_result[31:0]; flag = 1'b0; end
            AND:  begin r = a & b; flag = 1'b0; end
            OR:   begin r = a | b; flag = 1'b0; end
            XOR:  begin r = a ^ b; flag = 1'b0; end
            NOR:  begin r = ~(a | b); flag = 1'b0; end
            SLT:  begin r = ($signed(a) < $signed(b)); flag = r[0]; end
            SLTU: begin r = (a < b); flag = r[0]; end
            SLL:  begin r = b << shift_amount; flag = 1'b0; end
            SRL:  begin r = b >> shift_amount; flag = 1'b0; end
            SRA:  begin r = $signed(b) >>> shift_amount; flag = 1'b0; end
            SLLV: begin r = b << shift_amount; flag = 1'b0; end
            SRLV: begin r = b >> shift_amount; flag = 1'b0; end
            SRAV: begin r = $signed(b) >>> shift_amount; flag = 1'b0; end
            LUI:  begin r = {b[15:0], 16'b0}; flag = 1'b0; end
            default: begin r = 32'b0; flag = 1'b0; end
        endcase
        result_bus = r;
    end

endmodule
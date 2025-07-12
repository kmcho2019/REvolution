module TopModule(clk, reset, x, z);
    input clk, reset, x;
    output z;
    reg [2:0] y;
    always @(posedge clk) begin
        if(reset) begin
            y <= 3'b000;
        end else begin
            case(y)
                3'b000: y <= x ? 3'b001 : 3'b000;
                3'b001: y <= x ? 3'b100 : 3'b001;
                3'b010: y <= x ? 3'b001 : 3'b010;
                3'b011: y <= x ? 3'b010 : 3'b001;
                3'b100: y <= x ? 3'b100 : 3'b011;
                default: y <= 3'b000; // default to state 000
            endcase
        end
    end
    
    always @(y, x) begin
        case(y)
            3'b000: z = 0;
            3'b001: z = 0;
            3'b010: z = 0;
            3'b011: z = 1;
            3'b100: z = 1;
            default: z = 0; // default to z = 0
        endcase
    end
endmodule
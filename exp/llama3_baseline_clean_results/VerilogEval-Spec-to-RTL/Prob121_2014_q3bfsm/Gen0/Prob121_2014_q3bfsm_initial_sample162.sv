module TopModule(
    input  clk,
    input  reset,
    input  x,
    output reg z
);

    reg [2:0] y;

    always_ff @(posedge clk) begin
        if (reset) begin
            y <= 3'b000;
        end else begin
            case (y)
                3'b000: y <= x ? 3'b001 : 3'b000;
                3'b001: y <= x ? 3'b100 : 3'b001;
                3'b010: y <= x ? 3'b001 : 3'b010;
                3'b011: y <= x ? 3'b010 : 3'b001;
                3'b100: y <= x ? 3'b100 : 3'b011;
                default: y <= 3'b000; // Default to state 000 if invalid state
            endcase
        end
    end

    always_comb begin
        case (y)
            3'b000, 3'b001, 3'b010: z = 0;
            3'b011, 3'b100: z = 1;
            default: z = 0; // Default output to 0 if invalid state
        endcase
    end

endmodule
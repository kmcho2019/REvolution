module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

    reg [7:0] shift_reg;

    // Shift register shifting right, MSB fed from S
    always @(posedge clk) begin
        if (enable) begin
            shift_reg <= {S, shift_reg[7:1]};
        end
    end

    // Compute inverted index: idx = 7 - {A,B,C} = (~{A,B,C}) + 1
    wire [2:0] abc = {A, B, C};
    wire [2:0] idx = (~abc) + 3'd1;

    // Select bit from shift_reg using idx
    // Multiplexer implemented via a case statement (or direct indexing)
    reg z_reg;
    always @(*) begin
        case(idx)
            3'd0: z_reg = shift_reg[0];
            3'd1: z_reg = shift_reg[1];
            3'd2: z_reg = shift_reg[2];
            3'd3: z_reg = shift_reg[3];
            3'd4: z_reg = shift_reg[4];
            3'd5: z_reg = shift_reg[5];
            3'd6: z_reg = shift_reg[6];
            3'd7: z_reg = shift_reg[7];
            default: z_reg = 1'b0;
        endcase
    end

    assign Z = z_reg;

endmodule
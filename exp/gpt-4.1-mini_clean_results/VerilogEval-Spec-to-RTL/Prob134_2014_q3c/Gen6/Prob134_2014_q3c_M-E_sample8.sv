module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    reg [2:0] state_reg;
    reg       z_reg;

    wire [2:0] next_state;

    // Next state combinational logic based on current state_reg and input x
    assign next_state = (state_reg == 3'b000) ? (x ? 3'b001 : 3'b000) :
                        (state_reg == 3'b001) ? (x ? 3'b100 : 3'b001) :
                        (state_reg == 3'b010) ? (x ? 3'b001 : 3'b010) :
                        (state_reg == 3'b011) ? (x ? 3'b010 : 3'b001) :
                        (state_reg == 3'b100) ? (x ? 3'b100 : 3'b011) :
                        3'b000;

    // Output logic combinational from current state_reg
    always @(*) begin
        case(state_reg)
            3'b011,
            3'b100: z_reg = 1'b1;
            default: z_reg = 1'b0;
        endcase
    end

    // State register update on rising clock edge
    always @(posedge clk) begin
        state_reg <= y;  // Load external state input y synchronously
    end

    // Output assignments
    assign Y0 = next_state[0];
    assign z  = z_reg;

endmodule
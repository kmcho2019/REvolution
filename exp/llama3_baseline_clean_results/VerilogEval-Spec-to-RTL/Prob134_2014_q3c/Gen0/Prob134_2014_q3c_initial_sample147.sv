module TopModule(
    input  clk,
    input  x,
    input  [2:0] y,
    output Y0,
    output z
);

    // Combinational logic for next state Y[2:0]
    reg [2:0] nextState;

    always @(*) begin
        case(y)
            3'b000: nextState = (x) ? 3'b001 : 3'b000;
            3'b001: nextState = (x) ? 3'b100 : 3'b001;
            3'b010: nextState = (x) ? 3'b001 : 3'b010;
            3'b011: nextState = (x) ? 3'b010 : 3'b001;
            3'b100: nextState = (x) ? 3'b100 : 3'b011;
            default: nextState = 3'b000; // default next state
        endcase
    end

    // Sequential logic to update current state
    reg [2:0] currentState;
    always @(posedge clk) begin
        currentState <= nextState;
    end

    // Output logic for z
    always @(*) begin
        case(y)
            3'b000: z = 1'b0;
            3'b001: z = 1'b0;
            3'b010: z = 1'b0;
            3'b011: z = 1'b1;
            3'b100: z = 1'b1;
            default: z = 1'b0; // default output
        endcase
    end

    // Output logic for Y0
    assign Y0 = nextState[0];

    // Assign the current state to y
    assign y = currentState;

endmodule
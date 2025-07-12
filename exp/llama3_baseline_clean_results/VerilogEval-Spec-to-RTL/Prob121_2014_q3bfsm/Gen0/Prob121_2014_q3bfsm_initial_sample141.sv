module TopModule(clk, reset, x, z);
    input clk;
    input reset;
    input x;
    output z;

    reg [2:0] y; // Current state
    wire [2:0] next_state; // Next state
    reg z_reg; // Output register

    // Combinational logic to determine next state
    always @(*)
    begin
        case (y)
            3'b000: next_state = x ? 3'b001 : 3'b000;
            3'b001: next_state = x ? 3'b100 : 3'b001;
            3'b010: next_state = x ? 3'b001 : 3'b010;
            3'b011: next_state = x ? 3'b010 : 3'b001;
            3'b100: next_state = x ? 3'b100 : 3'b011;
            default: next_state = 3'b000; // Default to state 000 for invalid states
        endcase
    end

    // Determine output z based on current state
    always @(*)
    begin
        case (y)
            3'b011: z_reg = 1'b1;
            3'b100: z_reg = 1'b1;
            default: z_reg = 1'b0;
        endcase
    end

    // Sequential logic to update state on positive clock edge
    always @(posedge clk)
    begin
        if (reset)
            y <= 3'b000; // Synchronous reset
        else
            y <= next_state;
    end

    assign z = z_reg; // Continuous assignment for output

endmodule
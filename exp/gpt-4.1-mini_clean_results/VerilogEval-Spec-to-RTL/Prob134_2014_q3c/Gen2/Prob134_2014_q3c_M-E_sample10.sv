module TopModule (
    input clk,
    input x,
    input [2:0] y,   // external input to asynchronously load state
    output Y0,
    output z
);
    reg [2:0] state;
    reg [2:0] next_state;

    // Next state logic based on current state and input x
    always @(*) begin
        case (state)
            3'b000: next_state = (x == 0) ? 3'b000 : 3'b001;
            3'b001: next_state = (x == 0) ? 3'b001 : 3'b100;
            3'b010: next_state = (x == 0) ? 3'b010 : 3'b001;
            3'b011: next_state = (x == 0) ? 3'b001 : 3'b010;
            3'b100: next_state = (x == 0) ? 3'b011 : 3'b100;
            default: next_state = 3'b000;
        endcase
    end

    // Synchronous state update or async load from input y
    always @(posedge clk) begin
        state <= y;  // Asynchronously load external y as current state every clock cycle
    end

    // Output assignments
    assign z = (state == 3'b011) || (state == 3'b100);
    assign Y0 = next_state[0];

endmodule
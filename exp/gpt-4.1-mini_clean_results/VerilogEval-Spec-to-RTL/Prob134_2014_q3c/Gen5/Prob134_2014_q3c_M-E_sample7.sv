module TopModule (
    input clk,
    input x,
    input [2:0] y,   // used here as async reset/load value for initial state
    output reg Y0,
    output reg z
);

    reg [2:0] state;
    reg [2:0] next_state;

    // Asynchronous reset and state load with input y
    // This behavior assumes y is used as initial or reset state asynchronously.
    // For simplicity, we initialize state with y at start (can be adapted to async reset).
    initial begin
        state = 3'b000;
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
            3'b000: next_state = (x == 1'b0) ? 3'b000 : 3'b001;
            3'b001: next_state = (x == 1'b0) ? 3'b001 : 3'b100;
            3'b010: next_state = (x == 1'b0) ? 3'b010 : 3'b001;
            3'b011: next_state = (x == 1'b0) ? 3'b001 : 3'b010;
            3'b100: next_state = (x == 1'b0) ? 3'b011 : 3'b100;
            default: next_state = 3'b000;
        endcase
    end

    // State register update on clock
    always @(posedge clk) begin
        state <= y;         // Load initial state asynchronously from y every clock cycle (redefinable if needed)
    end

    // Outputs driven from current and next states
    always @(*) begin
        Y0 = next_state[0];
        z  = (state == 3'b011) || (state == 3'b100);
    end

endmodule
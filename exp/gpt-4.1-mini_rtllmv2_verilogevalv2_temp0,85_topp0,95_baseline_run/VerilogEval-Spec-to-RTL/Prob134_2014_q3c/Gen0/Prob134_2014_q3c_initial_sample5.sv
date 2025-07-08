module TopModule(
    input clk,
    input x,
    input [2:0] y,
    output reg Y0,
    output reg z
);

    reg [2:0] state;
    reg [2:0] next_state;

    // Compute next state based on present state and input x
    always @(*) begin
        case(state)
            3'b000: next_state = x ? 3'b001 : 3'b000;
            3'b001: next_state = x ? 3'b100 : 3'b001;
            3'b010: next_state = x ? 3'b001 : 3'b010;
            3'b011: next_state = x ? 3'b010 : 3'b001;
            3'b100: next_state = x ? 3'b100 : 3'b011;
            default: next_state = 3'b000; // safe default
        endcase
    end

    // Output z depends on present state
    always @(*) begin
        case(state)
            3'b011, 3'b100: z = 1'b1;
            default:       z = 1'b0;
        endcase
    end

    // Output Y0 is bit 0 of next state
    always @(*) begin
        Y0 = next_state[0];
    end

    // State register update on clock edge
    always @(posedge clk) begin
        state <= y;  // initialize state with input y on every clock as per interface
    end

endmodule
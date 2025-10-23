module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    reg [2:0] next_state;
    reg [2:0] current_state;

    // Next state and output logic
    always @(*) begin
        case (current_state)
            3'b000: next_state = x ? 3'b001 : 3'b000;
            3'b001: next_state = x ? 3'b100 : 3'b001;
            3'b010: next_state = x ? 3'b001 : 3'b010;
            3'b011: next_state = x ? 3'b010 : 3'b001;
            3'b100: next_state = x ? 3'b100 : 3'b011;
            default: next_state = 3'b000;
        endcase
    end

    // Output logic
    assign z = (current_state == 3'b011) || (current_state == 3'b100);
    assign Y0 = next_state[0];

    // State update
    always @(posedge clk) begin
        current_state <= y;
    end

endmodule
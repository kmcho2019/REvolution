module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    reg [3:0] shift_reg;
    wire [3:0] next_state;

    // Next state logic with circular feedback option
    assign next_state[0] = in;  // Normal serial input
    assign next_state[1] = shift_reg[0];
    assign next_state[2] = shift_reg[1];
    assign next_state[3] = shift_reg[2];  // Could make this shift_reg[3] for circular mode

    always @(posedge clk) begin
        if (!resetn) begin
            shift_reg <= 4'b0;
        end else begin
            shift_reg <= next_state;
        end
    end

    assign out = shift_reg[3];

endmodule
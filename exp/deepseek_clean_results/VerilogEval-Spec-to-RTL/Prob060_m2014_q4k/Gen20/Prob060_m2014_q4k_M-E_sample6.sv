module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    reg [3:0] shift_reg;
    wire [3:0] next_state;

    // Each stage can either hold, shift in new data, or circulate
    assign next_state[0] = in;  // First stage always takes new input
    assign next_state[1] = shift_reg[0];
    assign next_state[2] = shift_reg[1];
    assign next_state[3] = shift_reg[2];

    always @(posedge clk) begin
        if (!resetn) begin
            shift_reg <= 4'b0;
        end else begin
            shift_reg <= next_state;
        end
    end

    assign out = shift_reg[3];

endmodule
module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    wire [3:0] next_shift_reg;
    reg [3:0] shift_reg;
    reg found_reg;
    wire sequence_found;

    // Combinational logic for next shift register value
    assign next_shift_reg = found_reg ? shift_reg : {shift_reg[2:0], data};

    // Combinational detection of the sequence
    assign sequence_found = (shift_reg[2:0] == 3'b110) && (data == 1'b1);

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b0;
            found_reg <= 1'b0;
        end else begin
            shift_reg <= next_shift_reg;
            found_reg <= found_reg ? 1'b1 : sequence_found;
        end
    end

    assign start_shifting = found_reg;

endmodule
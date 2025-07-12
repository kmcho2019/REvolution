module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] shift_reg;

    // Combinational logic for next shift register value
    wire [9:0] next_shift = load ? {10{1'b1}} << (10 - data) : 
                           {shift_reg[8:0], 1'b0};

    // Sequential logic (D flip-flop)
    always @(posedge clk) begin
        if (load) begin
            // Initialize with right-aligned 1's
            shift_reg <= {10{1'b1}} << (10 - data);
        end else begin
            // Shift left with 0 input
            shift_reg <= {shift_reg[8:0], 1'b0};
        end
    end

    // Terminal count detection
    assign tc = (shift_reg == 0);

endmodule
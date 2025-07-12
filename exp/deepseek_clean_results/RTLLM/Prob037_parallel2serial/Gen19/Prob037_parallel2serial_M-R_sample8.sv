module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [3:0] shift_reg;
    reg [1:0] cycle_count;

    // Next state logic (combinational)
    wire [1:0] next_count = rst_n ? (cycle_count + 1'b1) : 2'b0;
    wire [3:0] next_shift = (cycle_count == 2'b11) ? d : {shift_reg[2:0], 1'b0};

    // Register updates (sequential)
    always @(posedge clk) begin
        shift_reg <= next_shift;
        cycle_count <= next_count;
    end

    // Output assignments
    assign valid_out = (cycle_count == 2'b00);
    assign dout = shift_reg[3];

endmodule
module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd number
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// Parameter validation
initial begin
    if (NUM_DIV % 2 == 0) begin
        $error("NUM_DIV must be an odd number");
        $finish;
    end
end

reg [NUM_DIV-1:0] shift_reg;
wire [NUM_DIV-1:0] next_shift_reg;

// Mathematical determination of XOR points
localparam FIRST_XOR_POINT = (NUM_DIV - 1)/2;
localparam SECOND_XOR_POINT = NUM_DIV - 1;

// Shift register rotation
assign next_shift_reg = {shift_reg[NUM_DIV-2:0], shift_reg[NUM_DIV-1]};

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Initialize with thermometer pattern (1 followed by 0s)
        shift_reg <= {{(NUM_DIV-1){1'b0}}, 1'b1};
    end else begin
        shift_reg <= next_shift_reg;
    end
end

// Generate output clock by XOR-ing specific stages
assign clk_div = shift_reg[FIRST_XOR_POINT] ^ shift_reg[SECOND_XOR_POINT];

endmodule
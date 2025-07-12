module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] q_reg;

// Decrement logic
wire [3:0] dec_val;
assign dec_val = (q_reg == 4'b0000) ? 4'b1111 : q_reg - 1;

// Shift logic
wire [3:0] shift_val;
assign shift_val = {data, q_reg[3:1]};

// Multiplexer select logic
wire [1:0] sel;
assign sel = {shift_ena, count_ena};

// Multiplexer
wire [3:0] next_q;
always @(*) begin
    case (sel)
        2'b01: next_q = dec_val; // Decrement
        2'b10: next_q = shift_val; // Shift
        default: next_q = q_reg; // Hold current value
    endcase
end

// Register update
always @(posedge clk) begin
    q_reg <= next_q;
end

assign q = q_reg;

endmodule
module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] q_reg;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        case (ena)
            2'b01: q_reg <= {q_reg[0], q_reg[99:1]}; // Rotate right
            2'b10: q_reg <= {q_reg[98:0], q_reg[99]}; // Rotate left
            default: q_reg <= q_reg; // No rotation
        endcase
    end
end

assign q = q_reg;

// Refactored code using conditional operator
// module TopModule (
//     input clk,
//     input load,
//     input [1:0] ena,
//     input [99:0] data,
//     output [99:0] q
// );

// reg [99:0] q_reg;
// reg [99:0] next_q;

// always @(posedge clk) begin
//     q_reg <= next_q;
// end

// assign next_q = load ? data : 
//                 (ena == 2'b01) ? {q_reg[0], q_reg[99:1]} : 
//                 (ena == 2'b10) ? {q_reg[98:0], q_reg[99]} : q_reg;

// assign q = q_reg;
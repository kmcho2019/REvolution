module TopModule (
    input  clk,
    input  load,
    input  [1:0] ena,
    input  [99:0] data,
    output [99:0] q
);

reg [99:0] q_reg;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        case (ena)
            2'b01: // rotate right
                q_reg <= {q_reg[0], q_reg[99:1]};
            2'b10: // rotate left
                q_reg <= {q_reg[98:0], q_reg[99]};
            default: // do not rotate
                q_reg <= q_reg;
        endcase
    end
end

assign q = q_reg;

// Alternative implementation using multiplexers and logic gates
// wire [99:0] rotate_right = {q_reg[0], q_reg[99:1]};
// wire [99:0] rotate_left = {q_reg[98:0], q_reg[99]};
// 
// always @(posedge clk) begin
//     if (load) begin
//         q_reg <= data;
//     end else begin
//         q_reg <= (ena == 2'b01)? rotate_right :
//                   (ena == 2'b10)? rotate_left :
//                   q_reg;
//     end
// end

// Another alternative implementation using conditional statements
// always @(posedge clk) begin
//     if (load) begin
//         q_reg <= data;
//     end else if (ena == 2'b01) begin
//         q_reg <= {q_reg[0], q_reg[99:1]};
//     end else if (ena == 2'b10) begin
//         q_reg <= {q_reg[98:0], q_reg[99]};
//     end else begin
//         q_reg <= q_reg;
//     end
// end

endmodule
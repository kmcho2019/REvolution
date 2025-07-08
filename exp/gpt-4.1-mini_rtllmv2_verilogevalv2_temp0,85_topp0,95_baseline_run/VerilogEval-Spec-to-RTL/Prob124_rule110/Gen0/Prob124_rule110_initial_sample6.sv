module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    // Combinational next state vector
    reg [511:0] next_q;

    integer i;
    always @(*) begin
        for (i = 0; i < 512; i = i + 1) begin
            // Determine neighbors with boundary conditions
            // left neighbor: q[i+1] if i<511 else 0
            // center: q[i]
            // right neighbor: q[i-1] if i>0 else 0
            wire left = (i < 511) ? q[i+1] : 1'b0;
            wire center = q[i];
            wire right = (i > 0) ? q[i-1] : 1'b0;

            // Apply Rule 110 truth table:
            // Using the mapping from (left, center, right) to next state:
            // 111->0, 110->1, 101->1, 100->0, 011->1, 010->1, 001->1, 000->0
            // This can be computed as:
            // next = (left & center & ~right) ? 0 :
            //        (left & center & right) ? 0 :
            // or better represented as a boolean expression derived from the truth table
            // The known boolean expression for Rule 110 next state:
            // next = (left & center & ~right) ? 0
            // next = (left & center & right) ? 0
            // Otherwise the next state is 1 if (left & center & ~right) or (left & ~center & right) or (~left & center & right) or (~left & center & ~right) or (~left & ~center & right)
            // Simplify with the known formula for Rule 110:
            // next = (left & center & ~right) ? 0
            // else if (left & center & right) ? 0
            // else 1 if (left & ~center & right) or (~left & center & right) or (~left & center & ~right) or (~left & ~center & right)
            // A simpler way is to encode the output directly:

            case ({left, center, right})
                3'b111: next_q[i] = 1'b0;
                3'b110: next_q[i] = 1'b1;
                3'b101: next_q[i] = 1'b1;
                3'b100: next_q[i] = 1'b0;
                3'b011: next_q[i] = 1'b1;
                3'b010: next_q[i] = 1'b1;
                3'b001: next_q[i] = 1'b1;
                3'b000: next_q[i] = 1'b0;
                default: next_q[i] = 1'b0; // Should never happen
            endcase
        end
    end

    // Sequential update on clock edge
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule
module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    wire [511:0] next_state;

    // Function to compute next state of a cell given its neighbors according to Rule 110
    function automatic bit rule110 (
        input bit left,
        input bit center,
        input bit right
    );
        begin
            // Rule 110 truth table encoded as per problem statement:
            // Inputs (L,C,R) => Next state
            // 111 => 0
            // 110 => 1
            // 101 => 1
            // 100 => 0
            // 011 => 1
            // 010 => 1
            // 001 => 1
            // 000 => 0

            case ({left, center, right})
                3'b111: rule110 = 1'b0;
                3'b110: rule110 = 1'b1;
                3'b101: rule110 = 1'b1;
                3'b100: rule110 = 1'b0;
                3'b011: rule110 = 1'b1;
                3'b010: rule110 = 1'b1;
                3'b001: rule110 = 1'b1;
                3'b000: rule110 = 1'b0;
                default: rule110 = 1'b0; // Should never happen
            endcase
        end
    endfunction

    genvar i;
    generate
        for (i=0; i < 512; i=i+1) begin : gen_next_state
            wire left_neighbor = (i == 511) ? 1'b0 : q[i+1];
            wire center_cell   = q[i];
            wire right_neighbor= (i == 0) ? 1'b0 : q[i-1];
            assign next_state[i] = rule110(left_neighbor, center_cell, right_neighbor);
        end
    endgenerate

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_state;
        end
    end

endmodule
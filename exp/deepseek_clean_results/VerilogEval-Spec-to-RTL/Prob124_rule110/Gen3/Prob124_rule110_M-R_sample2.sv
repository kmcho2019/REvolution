module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    function bit rule110(bit left, bit center, bit right);
        case ({left, center, right})
            3'b111: return 1'b0;
            3'b110: return 1'b1;
            3'b101: return 1'b1;
            3'b100: return 1'b0;
            3'b011: return 1'b1;
            3'b010: return 1'b1;
            3'b001: return 1'b1;
            3'b000: return 1'b0;
            default: return 1'b0;
        endcase
    endfunction

    wire [511:0] next_q;

    // Generate logic for each cell
    genvar i;
    generate
        // First cell (left boundary = 0)
        assign next_q[0] = rule110(1'b0, q[0], q[1]);

        // Middle cells
        for (i = 1; i < 511; i = i + 1) begin : middle_cells
            assign next_q[i] = rule110(q[i-1], q[i], q[i+1]);
        end

        // Last cell (right boundary = 0)
        assign next_q[511] = rule110(q[510], q[511], 1'b0);
    endgenerate

    always @(posedge clk) begin
        if (load) q <= data;
        else q <= next_q;
    end

endmodule
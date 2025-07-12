module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] next_q;
    parameter LEFT_BOUNDARY = 1'b0;
    parameter RIGHT_BOUNDARY = 1'b0;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

    always @(*) begin
        // Compute next state for all cells in parallel
        for (integer i = 0; i < 512; i = i + 1) begin
            reg left, right;
            
            // Handle boundary conditions
            left = (i == 0) ? LEFT_BOUNDARY : q[i-1];
            right = (i == 511) ? RIGHT_BOUNDARY : q[i+1];
            
            // Apply Rule 110
            next_q[i] = rule110(left, q[i], right);
        end
    end

    // Rule 110 logic function
    function rule110;
        input left, center, right;
        begin
            case ({left, center, right})
                3'b111: rule110 = 1'b0;
                3'b110: rule110 = 1'b1;
                3'b101: rule110 = 1'b1;
                3'b100: rule110 = 1'b0;
                3'b011: rule110 = 1'b1;
                3'b010: rule110 = 1'b1;
                3'b001: rule110 = 1'b1;
                3'b000: rule110 = 1'b0;
                default: rule110 = 1'b0;
            endcase
        end
    endfunction

endmodule
module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Function to compute Rule 110 next state
    function automatic rule110;
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

    // Combinational next state calculation
    wire [511:0] next_q;

    // Generate next state for each bit with optimized boundary handling
    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : rule110_gen
            // Get neighbors with boundary conditions
            wire left = (i == 511) ? 1'b0 : q[i+1];
            wire center = q[i];
            wire right = (i == 0) ? 1'b0 : q[i-1];
            
            // Apply Rule 110 function
            assign next_q[i] = rule110(left, center, right);
        end
    endgenerate

    // State transition logic
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule
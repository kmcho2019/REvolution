module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Combinational next state calculation
    wire [511:0] next_q;

    // Optimized Rule 110 lookup function
    function automatic rule110;
        input left, center, right;
        begin
            case ({left, center, right})
                3'b111: rule110 = 1'b0;
                3'b110, 3'b101, 3'b011, 3'b010, 3'b001: rule110 = 1'b1;
                default: rule110 = 1'b0; // covers 3'b100 and 3'b000
            endcase
        end
    endfunction

    // Generate next state for each bit
    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : rule110
            // Get neighbors with boundary conditions
            wire left = (i == 511) ? 1'b0 : q[i+1];
            wire center = q[i];
            wire right = (i == 0) ? 1'b0 : q[i-1];
            
            // Use optimized function
            assign next_q[i] = rule110(left, center, right);
        end
    endgenerate

    // State transition logic with efficient updating
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q; // Simple parallel update - more efficient than conditional
        end
    end

endmodule
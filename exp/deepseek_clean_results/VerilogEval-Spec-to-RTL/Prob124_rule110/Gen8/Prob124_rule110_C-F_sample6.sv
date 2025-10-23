module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] next_q;
    genvar i;

    // Function to compute Rule 110
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
            endcase
        end
    endfunction

    generate
        for (i = 0; i < 512; i = i + 1) begin : rule110_gen
            // Get neighbors with boundary conditions
            wire left = (i == 511) ? 1'b0 : q[i+1];
            wire center = q[i];
            wire right = (i == 0) ? 1'b0 : q[i-1];
            
            // Compute next state using shared function
            assign next_q[i] = rule110(left, center, right);
        end
    endgenerate

    // State transition logic with conditional update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Only update bits that will change
            for (integer j = 0; j < 512; j = j + 1) begin
                if (q[j] != next_q[j]) begin
                    q[j] <= next_q[j];
                end
            end
        end
    end

endmodule
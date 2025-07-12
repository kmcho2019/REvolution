module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Temporary extended register for boundary conditions
    reg [513:0] extended_q;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Update the extended register with current state and boundaries
            extended_q <= {1'b0, q, 1'b0};
            
            // Apply Rule 110 to all cells in parallel
            for (integer i = 1; i <= 512; i = i + 1) begin
                case ({extended_q[i+1], extended_q[i], extended_q[i-1]})
                    3'b111: q[i-1] <= 1'b0;
                    3'b110: q[i-1] <= 1'b1;
                    3'b101: q[i-1] <= 1'b1;
                    3'b100: q[i-1] <= 1'b0;
                    3'b011: q[i-1] <= 1'b1;
                    3'b010: q[i-1] <= 1'b1;
                    3'b001: q[i-1] <= 1'b1;
                    3'b000: q[i-1] <= 1'b0;
                endcase
            end
        end
    end

endmodule
module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Extended register for boundary conditions
    reg [513:0] q_ext;
    
    always @(posedge clk) begin
        if (load) begin
            q <= data;
            q_ext <= {1'b0, data, 1'b0};
        end else begin
            // Update main register
            q <= q_ext[512:1];
            
            // Update extended register with boundary conditions
            q_ext[513] <= 1'b0;  // Fixed left boundary
            q_ext[0] <= 1'b0;     // Fixed right boundary
            
            // Compute next states for all bits in parallel
            for (int i = 1; i <= 512; i = i + 1) begin
                case ({q_ext[i+1], q_ext[i], q_ext[i-1]})
                    3'b111: q_ext[i] <= 1'b0;
                    3'b110: q_ext[i] <= 1'b1;
                    3'b101: q_ext[i] <= 1'b1;
                    3'b100: q_ext[i] <= 1'b0;
                    3'b011: q_ext[i] <= 1'b1;
                    3'b010: q_ext[i] <= 1'b1;
                    3'b001: q_ext[i] <= 1'b1;
                    3'b000: q_ext[i] <= 1'b0;
                endcase
            end
        end
    end

endmodule
module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg; // Register to hold the current state of the cells

// Initialize q_reg with the input data when load is high
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        // Compute the next state of each cell based on Rule 110
        for (int i = 0; i < 512; i++) begin
            reg left, center, right;
            // Handle boundaries
            if (i == 0) begin
                left = 0;
            end else begin
                left = q_reg[i-1];
            end
            
            center = q_reg[i];
            
            if (i == 511) begin
                right = 0;
            end else begin
                right = q_reg[i+1];
            end
            
            // Apply Rule 110
            case ({left, center, right})
                3'b111: q_reg[i] <= 0;
                3'b110: q_reg[i] <= 1;
                3'b101: q_reg[i] <= 1;
                3'b100: q_reg[i] <= 0;
                3'b011: q_reg[i] <= 1;
                3'b010: q_reg[i] <= 1;
                3'b001: q_reg[i] <= 1;
                3'b000: q_reg[i] <= 0;
                default: q_reg[i] <= 0;
            endcase
        end
    end
end

// Continuous assignment to output q
assign q = q_reg;

endmodule
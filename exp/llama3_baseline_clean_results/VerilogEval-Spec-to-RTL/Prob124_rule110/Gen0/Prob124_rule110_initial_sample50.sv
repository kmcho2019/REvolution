module TopModule (
    input  clk,
    input  load,
    input  [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg; // register to store the current state

// assign the output
assign q = q_reg;

always @(posedge clk) begin
    if (load) begin
        // load the initial state
        q_reg <= data;
    end else begin
        // advance the system by one time step
        for (int i = 0; i < 512; i++) begin
            reg left, center, right;
            if (i == 0) begin
                left = 0; // boundary
            end else begin
                left = q_reg[i-1];
            end
            
            center = q_reg[i];
            
            if (i == 511) begin
                right = 0; // boundary
            end else begin
                right = q_reg[i+1];
            end
            
            // implement Rule 110
            case ({left, center, right})
                3'b111: q_reg[i] <= 0;
                3'b110: q_reg[i] <= 1;
                3'b101: q_reg[i] <= 1;
                3'b100: q_reg[i] <= 0;
                3'b011: q_reg[i] <= 1;
                3'b010: q_reg[i] <= 1;
                3'b001: q_reg[i] <= 1;
                3'b000: q_reg[i] <= 0;
                default: q_reg[i] <= 0; // handle any unexpected values
            endcase
        end
    end
end

endmodule
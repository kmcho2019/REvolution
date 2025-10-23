module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] current_state;
reg [511:0] next_state;

integer i;
always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    for (i = 0; i < 512; i++) begin
        reg left, center, right;
        
        // Handle boundary conditions
        if (i == 0) begin
            left = 1'b0;
        end else begin
            left = current_state[i-1];
        end
        
        center = current_state[i];
        
        if (i == 511) begin
            right = 1'b0;
        end else begin
            right = current_state[i+1];
        end
        
        // Simplify the case statement for Rule 110 logic
        reg [2:0] neighbors;
        assign neighbors = {left, center, right};
        
        case (neighbors)
            3'b111: next_state[i] = 1'b0;
            3'b110, 3'b101, 3'b011, 3'b010, 3'b001: next_state[i] = 1'b1;
            default: next_state[i] = 1'b0; // default value for 3'b000 and any other unexpected values
        endcase
    end
end

assign q = current_state;

endmodule
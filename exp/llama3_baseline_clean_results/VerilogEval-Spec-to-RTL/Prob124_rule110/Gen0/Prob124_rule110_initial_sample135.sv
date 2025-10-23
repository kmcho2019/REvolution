module TopModule(
    input  clk,
    input  load,
    input  [511:0] data,
    output [511:0] q
);

reg [511:0] current_state;
reg [511:0] next_state;

// Initialize the output
assign q = current_state;

// Combinational logic to calculate the next state
always @(*)
begin
    for (int i = 0; i < 512; i++)
    begin
        reg left, center, right, next;
        
        // Boundary conditions
        if (i == 0)
            left = 1'b0;
        else
            left = current_state[i-1];
        
        center = current_state[i];
        
        if (i == 511)
            right = 1'b0;
        else
            right = current_state[i+1];
        
        // Apply Rule 110
        case ({left, center, right})
            3'b111: next = 1'b0;
            3'b110: next = 1'b1;
            3'b101: next = 1'b1;
            3'b100: next = 1'b0;
            3'b011: next = 1'b1;
            3'b010: next = 1'b1;
            3'b001: next = 1'b1;
            3'b000: next = 1'b0;
            default: next = 1'bx; // This should never happen
        endcase
        
        next_state[i] = next;
    end
end

// Sequential logic to update the current state
always @(posedge clk)
begin
    if (load)
        current_state <= data;
    else
        current_state <= next_state;
end

endmodule
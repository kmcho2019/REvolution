module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] shift_register;

// Load the initial data into the shift register
always @(posedge clk) begin
    if (load) begin
        shift_register <= data;
    end else begin
        // Shift the register to the right and compute the new leftmost bit
        reg [2:0] left, center, right;
        reg [511:0] next_state;
        
        // Compute the next state
        for (int i = 0; i < 512; i++) begin
            left = (i == 0)? 1'b0 : shift_register[i - 1];
            center = shift_register[i];
            right = (i == 511)? 1'b0 : shift_register[i + 1];
            
            // Rule 110 transition rules
            if ({left, center, right} == 3'b111) begin
                next_state[i] = 1'b0;
            end else if ({left, center, right} == 3'b110) begin
                next_state[i] = 1'b1;
            end else if ({left, center, right} == 3'b101) begin
                next_state[i] = 1'b1;
            end else if ({left, center, right} == 3'b100) begin
                next_state[i] = 1'b0;
            end else if ({left, center, right} == 3'b011) begin
                next_state[i] = 1'b1;
            end else if ({left, center, right} == 3'b010) begin
                next_state[i] = 1'b1;
            end else if ({left, center, right} == 3'b001) begin
                next_state[i] = 1'b1;
            end else begin
                next_state[i] = 1'b0;
            end
        end
        
        // Update the shift register
        shift_register <= next_state;
    end
end

assign q = shift_register;

endmodule
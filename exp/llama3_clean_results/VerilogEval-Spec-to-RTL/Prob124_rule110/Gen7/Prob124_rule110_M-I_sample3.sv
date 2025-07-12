module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] current_state;
reg [511:0] next_state;

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    next_state = current_state;
    
    for (integer i = 0; i < 512; i++) begin
        reg [2:0] lut_input;
        
        // Correctly apply boundary conditions
        lut_input[2] = (i == 0)? 1'b0 : current_state[i - 1]; // Left neighbor
        lut_input[1] = current_state[i]; // Center cell
        lut_input[0] = (i == 511)? 1'b0 : current_state[i + 1]; // Right neighbor
        
        // Simplified case statement for Rule 110
        case (lut_input)
            3'b111: next_state[i] = 1'b0;
            3'b110, 3'b101, 3'b011, 3'b010, 3'b001: next_state[i] = 1'b1;
            default: next_state[i] = 1'b0;
        endcase
    end
end

assign q = current_state;

endmodule
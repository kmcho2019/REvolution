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
        // Compute the next state
        reg [511:0] next_state;
        
        // Rule 110 transition rules
        for (int i = 0; i < 512; i++) begin
            reg left, center, right;
            left = (i == 0) ? 1'b0 : shift_register[i - 1];
            center = shift_register[i];
            right = (i == 511) ? 1'b0 : shift_register[i + 1];
            
            case ({left, center, right})
                3'b111: next_state[i] = 1'b0;
'b110, 3'b101, 3'b011, 3'b010, 3'b001: next_state[i] = 1'b1;
                default: next_state[i] = 1'b0;
            endcase
        end
        
        // Update the shift register
        shift_register <= next_state;
    end
end

assign q = shift_register;

endmodule
module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] current_state;

integer i;
always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        for (i = 0; i < 512; i++) begin
            reg left, center, right;
            
            // Handle boundary conditions
            left = (i == 0)? 1'b0 : current_state[i-1];
            center = current_state[i];
            right = (i == 511)? 1'b0 : current_state[i+1];
            
            // Apply Rule 110 logic using case statement
            case ({left, center, right})
                3'b111: current_state[i] <= 1'b0;
                3'b110, 3'b101, 3'b011, 3'b010, 3'b001: current_state[i] <= 1'b1;
                default: current_state[i] <= 1'b0;
            endcase
        end
    end
end

assign q = current_state;

endmodule
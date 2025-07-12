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
            reg [1:0] left, center, right;
            
            // Handle boundary conditions
            left = (i == 0)? 2'b00 : {1'b0, current_state[i-1]};
            center = {1'b0, current_state[i]};
            right = (i == 511)? 2'b00 : {1'b0, current_state[i+1]};
            
            // Apply Rule 110 logic using a case statement
            case ({left[0], center[0], right[0]})
                3'b111: current_state[i] <= 1'b0;
                3'b110: current_state[i] <= 1'b1;
                3'b101: current_state[i] <= 1'b1;
                3'b100: current_state[i] <= 1'b0;
                3'b011: current_state[i] <= 1'b1;
                3'b010: current_state[i] <= 1'b1;
                3'b001: current_state[i] <= 1'b1;
                default: current_state[i] <= 1'b0; // 3'b000
            endcase
        end
    end
end

assign q = current_state;

endmodule
module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] current_state;

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        reg [511:0] next_state;
        integer i;
        for (i = 0; i < 512; i++) begin
            reg [2:0] neighbors;
            // Handle boundary conditions
            neighbors[0] = (i == 0) ? 1'b0 : current_state[i-1];
            neighbors[1] = current_state[i];
            neighbors[2] = (i == 511) ? 1'b0 : current_state[i+1];
            
            // Apply Rule 110 logic
            case ({neighbors[0], neighbors[1], neighbors[2]})
                3'b111: next_state[i] = 1'b0;
                3'b110, 3'b101, 3'b011, 3'b001: next_state[i] = 1'b1;
                default: next_state[i] = 1'b0;
            endcase
        end
        current_state <= next_state;
    end
end

assign q = current_state;

endmodule
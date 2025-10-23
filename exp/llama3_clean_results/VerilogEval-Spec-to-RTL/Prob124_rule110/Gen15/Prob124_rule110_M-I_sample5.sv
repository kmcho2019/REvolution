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
        left = (i == 0)? 1'b0 : current_state[i-1];
        center = current_state[i];
        right = (i == 511)? 1'b0 : current_state[i+1];
        
        // Apply Rule 110 logic using LUT
        reg [2:0] lut_input;
        lut_input = {left, center, right};
        
        reg [1:0] lut;
        always @(*) begin
            case (lut_input)
                3'b111: lut = 2'b00; // next_state = 0
                3'b110: lut = 2'b01; // next_state = 1
                3'b101: lut = 2'b01; // next_state = 1
                3'b100: lut = 2'b00; // next_state = 0
                3'b011: lut = 2'b01; // next_state = 1
                3'b010: lut = 2'b01; // next_state = 1
                3'b001: lut = 2'b01; // next_state = 1
                3'b000: lut = 2'b00; // next_state = 0
                default: lut = 2'b00; // This line should never be reached
            endcase
        end
        
        next_state[i] = lut[0];
    end
end

assign q = current_state;

endmodule
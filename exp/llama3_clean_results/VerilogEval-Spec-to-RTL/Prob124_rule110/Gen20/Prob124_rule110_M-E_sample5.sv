module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] current_state;

// LUT for Rule 110
wire [1:0] lut_output;
reg [1:0] lut [7:0];
always @(current_state) begin
    lut[0] = 2'b00; // 000
    lut[1] = 2'b00; // 001
    lut[2] = 2'b01; // 010
    lut[3] = 2'b01; // 011
    lut[4] = 2'b01; // 100
    lut[5] = 2'b01; // 101
    lut[6] = 2'b00; // 110
    lut[7] = 2'b00; // 111
    lut_output = lut[{current_state[0], current_state[1], current_state[2]}];
end

// Shift register to compute the next state
reg [511:0] next_state;
always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        for (int i = 0; i < 512; i++) begin
            reg [1:0] left, center, right;
            reg [2:0] input;
            reg [1:0] lut_output;
            
            // Determine the states of the neighbors
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
            
            // Use LUT to compute the next state
            input = {left, center, right};
            case (input)
                3'b000: lut_output = 2'b00;
                3'b001: lut_output = 2'b00;
                3'b010: lut_output = 2'b01;
                3'b011: lut_output = 2'b01;
                3'b100: lut_output = 2'b01;
                3'b101: lut_output = 2'b01;
                3'b110: lut_output = 2'b00;
                3'b111: lut_output = 2'b00;
                default: lut_output = 2'bxx;
            endcase
            
            next_state[i] <= lut_output[0];
        end
        current_state <= next_state;
    end
end

assign q = current_state;

endmodule
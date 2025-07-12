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

wire [2**3-1:0] lut [0:7] = {
    8'b00001010,  // 000
    8'b00001010,  // 001
    8'b00001010,  // 010
    8'b00001010,  // 011
    8'b00001010,  // 100
    8'b00001010,  // 101
    8'b00001010,  // 110
    8'b00001010   // 111
};

integer i;
genvar j;
generate
    for (j = 0; j < 512; j++) begin
        wire [2:0] input;
        assign input[0] = (j == 0)? 1'b0 : current_state[j-1];
        assign input[1] = current_state[j];
        assign input[2] = (j == 511)? 1'b0 : current_state[j+1];
        
        // Apply Rule 110 logic using LUT
        assign next_state[j] = lut[input];
    end
endgenerate

assign q = current_state;

endmodule
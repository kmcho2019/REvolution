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
    reg [2:0] lut_input;
    reg lut_output;
    
    next_state = current_state;
    
    for (integer i = 0; i < 512; i++) begin
        lut_input = {current_state[i], (i == 0)? 1'b0 : current_state[i - 1], (i == 511)? 1'b0 : current_state[i + 1]};
        
        case (lut_input)
            3'b111: lut_output = 1'b0;
            3'b110: lut_output = 1'b1;
            3'b101: lut_output = 1'b1;
            3'b100: lut_output = 1'b0;
            3'b011: lut_output = 1'b1;
            3'b010: lut_output = 1'b1;
            3'b001: lut_output = 1'b1;
            3'b000: lut_output = 1'b0;
            default: lut_output = 1'b0;
        endcase
        
        next_state[i] = lut_output;
    end
end

assign q = current_state;

endmodule
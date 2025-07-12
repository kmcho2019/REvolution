module TopModule (
    input [7:0] code,
    output reg [3:0] out,
    output reg valid
);

// Define scancode to digit mapping
parameter NUM_KEYS = 10;
reg [7:0] scancodes [0:NUM_KEYS-1];
reg [3:0] digits [0:NUM_KEYS-1];
integer i;

initial begin
    // Initialize the lookup tables
    scancodes[0] = 8'h45; digits[0] = 4'd0;
    scancodes[1] = 8'h16; digits[1] = 4'd1;
    scancodes[2] = 8'h1e; digits[2] = 4'd2;
    scancodes[3] = 8'h26; digits[3] = 4'd3;
    scancodes[4] = 8'h25; digits[4] = 4'd4;
    scancodes[5] = 8'h2e; digits[5] = 4'd5;
    scancodes[6] = 8'h36; digits[6] = 4'd6;
    scancodes[7] = 8'h3d; digits[7] = 4'd7;
    scancodes[8] = 8'h3e; digits[8] = 4'd8;
    scancodes[9] = 8'h46; digits[9] = 4'd9;
end

always @(*) begin
    valid = 1'b0;
    out = 4'd0;
    
    // Check all possible matches
    for (i = 0; i < NUM_KEYS; i = i + 1) begin
        if (code == scancodes[i]) begin
            out = digits[i];
            valid = 1'b1;
        end
    end
end

endmodule
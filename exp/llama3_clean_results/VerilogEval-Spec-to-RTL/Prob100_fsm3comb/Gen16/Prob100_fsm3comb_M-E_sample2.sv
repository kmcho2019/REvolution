module TopModule(
    input  in,
    input [1:0] state,
    output reg [1:0] next_state,
    output reg out
);

// Define the LUT for next state and output
reg [1:0] lut_ns [3:0][1:0];
reg [0:0] lut_out [3:0][1:0];

initial begin
    // Initialize the LUT for next state
    lut_ns[0][0] = 2'b00; // State A, in=0
    lut_ns[0][1] = 2'b01; // State A, in=1
    lut_ns[1][0] = 2'b10; // State B, in=0
    lut_ns[1][1] = 2'b01; // State B, in=1
    lut_ns[2][0] = 2'b00; // State C, in=0
    lut_ns[2][1] = 2'b11; // State C, in=1
    lut_ns[3][0] = 2'b10; // State D, in=0
    lut_ns[3][1] = 2'b01; // State D, in=1
    
    // Initialize the LUT for output
    lut_out[0][0] = 1'b0; // State A, in=0
    lut_out[0][1] = 1'b0; // State A, in=1
    lut_out[1][0] = 1'b0; // State B, in=0
    lut_out[1][1] = 1'b0; // State B, in=1
    lut_out[2][0] = 1'b0; // State C, in=0
    lut_out[2][1] = 1'b0; // State C, in=1
    lut_out[3][0] = 1'b1; // State D, in=0
    lut_out[3][1] = 1'b1; // State D, in=1
end

always @(*) begin
    case(state)
        2'b00: begin
            next_state = lut_ns[0][in];
            out = lut_out[0][in];
        end
        2'b01: begin
            next_state = lut_ns[1][in];
            out = lut_out[1][in];
        end
        2'b10: begin
            next_state = lut_ns[2][in];
            out = lut_out[2][in];
        end
        2'b11: begin
            next_state = lut_ns[3][in];
            out = lut_out[3][in];
        end
        default: begin
            next_state = 2'b00; // Default to state A
            out = 1'b0;
        end
    endcase
end

endmodule
module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

reg [1:0] state;                 // Current state of the FSM
reg [3:0] data;                   // Register to hold the input data

// Assign valid signal based on state
assign valid_out = (state != 2'b00);   

// Assign bit from input data based on state
always @(*) begin
    case (state)
        2'b01: dout = data[3];
        2'b10: dout = data[2];
        2'b11: dout = data[1];
        default: dout = data[0];
    endcase
end

// Sequential logic for FSM
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset FSM on reset
        state <= 2'b00;
        data <= 4'b0000;
    end else begin
        case (state)
            2'b00: begin
                // Load input data and move to next state
                data <= d;
                state <= 2'b01;
            end
            2'b01: state <= 2'b10;
            2'b10: state <= 2'b11;
            2'b11: state <= 2'b00;
            default: state <= 2'b00;
        endcase
    end
end

endmodule
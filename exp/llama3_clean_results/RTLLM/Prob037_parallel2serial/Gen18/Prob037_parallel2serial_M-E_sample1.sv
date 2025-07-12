module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

reg [1:0] state;                  // Finite state machine state
reg [3:0] data_reg;               // Register to hold the input data

// Sequential logic for FSM
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset FSM to idle state
        state <= 2'b00;
        data_reg <= 4'b0000;
    end else begin
        case (state)
            2'b00: begin
                // Idle state, wait for new data
                if (d!= 4'b0000) begin
                    data_reg <= d;
                    state <= 2'b01;
                end
            end
            2'b01: begin
                // Output MSB
                state <= 2'b10;
            end
            2'b10: begin
                // Output second bit
                state <= 2'b11;
            end
            2'b11: begin
                // Output third bit
                state <= 2'b00;
            end
            default: state <= 2'b00;
        endcase
    end
end

// Combinational logic for output
assign dout = (state == 2'b01)? data_reg[3] :
               (state == 2'b10)? data_reg[2] :
               (state == 2'b11)? data_reg[1] :
               data_reg[0];

assign valid_out = (state!= 2'b00);

endmodule
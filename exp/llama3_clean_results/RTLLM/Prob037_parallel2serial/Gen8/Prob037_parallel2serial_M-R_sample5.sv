module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

// Internal registers
reg [3:0] data_reg;              // Data register to store the parallel input
reg [1:0] cnt;                   // Counter to keep track of the bits
reg [1:0] state;                 // State register for the FSM

// Assign valid signal based on state
assign valid_out = (state == 0) ? 1 : 0;

// Assign serial output based on state and data register
assign dout = (state == 0) ? data_reg[3] :
              (state == 1) ? data_reg[2] :
              (state == 2) ? data_reg[1] :
              (state == 3) ? data_reg[0] : 1'b0;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset all internal registers
        data_reg <= 4'b0000;
        cnt <= 2'b00;
        state <= 2'b00;
    end else begin
        case (state)
            0: begin
                // If state is 0, update data register and increment state
                data_reg <= d;
                state <= state + 1;
            end
            1: begin
                // If state is 1, increment state
                state <= state + 1;
            end
            2: begin
                // If state is 2, increment state
                state <= state + 1;
            end
            3: begin
                // If state is 3, reset state
                state <= 2'b00;
            end
        endcase
    end
end

endmodule
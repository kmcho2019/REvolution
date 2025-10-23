module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

// Internal registers
reg [3:0] shift_reg;              // 4-bit shift register
reg [1:0] cnt;                   // 2-bit counter

// Control unit
reg load_data;                   // Load data signal
reg clk_enable;                  // Clock enable signal

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset all internal registers
        shift_reg <= 4'b0000;
        cnt <= 2'b00;
        load_data <= 1'b0;
        clk_enable <= 1'b0;
    end else begin
        // Update control signals
        load_data <= (cnt == 3)? 1'b1 : 1'b0;
        clk_enable <= (cnt!= 3)? 1'b1 : 1'b0;

        // Update counter
        if (cnt == 3) begin
            cnt <= 2'b00;
        end else begin
            cnt <= cnt + 1;
        end

        // Update shift register
        if (load_data) begin
            shift_reg <= d;
        end else if (clk_enable) begin
            shift_reg <= {shift_reg[2:0], 1'b0};
        end
    end
end

// Assign valid signal and serial output
assign valid_out = (cnt!= 3)? 1'b1 : 1'b0;
assign dout = shift_reg[3];

endmodule
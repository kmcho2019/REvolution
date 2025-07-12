module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output wire dout
);

    reg [3:0] shift_reg;
    reg load_pulse;
    reg load_delay;

    // Shift register and load pulse generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 4'b0;
            load_pulse <= 1'b0;
            load_delay <= 1'b0;
        end else begin
            // Generate load pulse every 4 cycles
            load_pulse <= (load_delay == 1'b1) ? 1'b0 : 
                         (shift_reg == 4'b0) ? 1'b1 : load_pulse;
            
            // Delay load_pulse for valid_out generation
            load_delay <= load_pulse;
            
            // Shift register operation
            if (load_pulse) begin
                shift_reg <= d;  // Load new data
            end else begin
                shift_reg <= {shift_reg[2:0], 1'b0};  // Right shift
            end
        end
    end

    // Output assignments
    assign dout = shift_reg[3];  // Always output MSB
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            valid_out <= 1'b0;
        else
            valid_out <= load_pulse;  // Valid when new data is loaded
    end

endmodule
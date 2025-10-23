module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [3:0] shift_reg;
    reg [3:0] shift_en;  // One-hot shift enable
    wire reload;
    
    // Continuous assignments
    assign dout = shift_reg[3];  // Always output MSB
    assign valid_out = reload;   // Valid when reloading new data
    assign reload = (shift_en == 4'b1000);  // Detect last shift
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 4'b0;
            shift_en <= 4'b0001;
        end else begin
            if (reload) begin
                // Load new data and reset shift enable
                shift_reg <= d;
                shift_en <= 4'b0001;
            end else begin
                // Shift left and rotate shift enable
                shift_reg <= {shift_reg[2:0], 1'b0};
                shift_en <= {shift_en[2:0], shift_en[3]};
            end
        end
    end

endmodule
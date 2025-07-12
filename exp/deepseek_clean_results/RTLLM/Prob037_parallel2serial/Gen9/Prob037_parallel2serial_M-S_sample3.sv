module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [3:0] shift_reg;
    reg load_new;
    
    // Continuous assignments
    assign dout = shift_reg[3];  // Always output MSB
    assign valid_out = load_new; // Valid when new data is loaded
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 4'b0;
            load_new <= 1'b1;    // Ready to load new data after reset
        end else begin
            if (load_new) begin
                shift_reg <= d;  // Load new parallel data
                load_new <= 1'b0;
            end else begin
                shift_reg <= {shift_reg[2:0], 1'b0}; // Shift left
                if (&shift_reg[2:0]) begin // All bits shifted out
                    load_new <= 1'b1;
                end
            end
        end
    end

endmodule
module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [3:0] shift_reg;
    reg load_new;
    reg valid;

    // Shift register control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 4'b0;
            load_new <= 1'b1;  // Load on first cycle after reset
        end else begin
            if (load_new) begin
                shift_reg <= d;
                load_new <= 1'b0;
            end else begin
                shift_reg <= {shift_reg[2:0], 1'b0};  // Shift left
                if (&shift_reg[2:0])  // When only 1 bit remains
                    load_new <= 1'b1;
            end
        end
    end

    // Valid signal generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            valid <= 1'b0;
        else
            valid <= load_new;
    end

    assign dout = shift_reg[3];
    assign valid_out = valid;

endmodule
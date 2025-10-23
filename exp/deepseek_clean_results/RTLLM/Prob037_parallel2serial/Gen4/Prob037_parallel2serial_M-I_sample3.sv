module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [3:0] shift_reg;
    wire [3:0] next_shift;
    wire shift_enable;
    wire load_new = (shift_reg == 4'b0001); // Last state

    // Clock gating control
    assign shift_enable = !load_new;

    // Next state logic (combinational)
    assign next_shift = load_new ? d : 
                       {shift_reg[2:0], 1'b0};

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 4'b0001; // Initialize to state 1
            valid_out <= 1'b0;
            dout <= 1'b0;
        end else begin
            if (shift_enable) begin
                shift_reg <= next_shift;
            end

            // Output logic
            if (load_new) begin
                valid_out <= 1'b1;
                dout <= d[3];  // Output MSB immediately
            end else begin
                valid_out <= 1'b0;
                dout <= shift_reg[3];  // Current MSB
            end
        end
    end

endmodule
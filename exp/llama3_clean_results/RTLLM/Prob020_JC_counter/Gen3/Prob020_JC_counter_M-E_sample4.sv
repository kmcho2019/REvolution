module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

reg [63:0] shift_reg;
reg [5:0] control;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        Q <= 64'd0;
        shift_reg <= 64'd0;
        control <= 6'd0;
    end else begin
        // Control unit
        if (Q[0] == 1'b0) begin
            control <= control + 1;
        end else begin
            control <= control - 1;
        end

        // Data unit
        if (control[0] == 1'b0) begin
            // Increment
            shift_reg <= {1'b1, Q[63:1]};
        end else begin
            // Decrement
            shift_reg <= {1'b0, Q[63:1]};
        end

        Q <= shift_reg;
    end
end

endmodule
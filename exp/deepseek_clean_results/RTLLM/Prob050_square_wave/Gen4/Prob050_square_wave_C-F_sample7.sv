module square_wave (
    input clk,
    input [7:0] freq,
    output wave_out
);

    reg [7:0] count;
    reg out_reg = 0;
    
    always @(posedge clk) begin
        if (freq == 0) begin
            // Handle zero frequency case
            out_reg <= 1'b0;
            count <= 0;
        end else if (count == 0) begin
            // Toggle output and reload counter
            out_reg <= ~out_reg;
            count <= freq - 1;
        end else begin
            // Decrement counter
            count <= count - 1;
        end
    end
    
    // Continuous output assignment
    assign wave_out = out_reg;

endmodule
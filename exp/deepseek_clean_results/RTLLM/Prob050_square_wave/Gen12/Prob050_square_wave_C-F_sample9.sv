module square_wave (
    input clk,
    input [7:0] freq,
    output wave_out
);

    reg [7:0] count = 0;
    reg out_reg = 0;
    
    // Continuous output assignment
    assign wave_out = (freq == 0) ? 1'b0 : out_reg;
    
    // Single always block for all sequential logic
    always @(posedge clk) begin
        if (freq == 0) begin
            // Freeze state when freq=0
            count <= 0;
            out_reg <= 0;
        end else begin
            if (count == 0) begin
                // Toggle output and reload counter
                out_reg <= ~out_reg;
                count <= freq - 1;
            end else begin
                // Decrement counter
                count <= count - 1;
            end
        end
    end

endmodule
module square_wave (
    input clk,
    input [7:0] freq,
    output wave_out
);

    reg [7:0] count = 0;
    reg toggle = 0;
    
    // Continuous assignment for clean output
    assign wave_out = (freq == 0) ? 1'b0 : toggle;
    
    // Single always block for sequential elements
    always @(posedge clk) begin
        if (freq == 0) begin
            count <= 0;
            toggle <= 0;
        end else begin
            if (count == freq - 1) begin
                count <= 0;
                toggle <= ~toggle;
            end else begin
                count <= count + 1;
            end
        end
    end

endmodule
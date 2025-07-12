module square_wave (
    input clk,
    input [7:0] freq,
    output wave_out
);

    reg [6:0] count;
    reg toggle;
    
    // Down counter implementation
    always @(posedge clk) begin
        if (count == 0)
            count <= freq[6:0];
        else
            count <= count - 1;
    end
    
    // Toggle generation
    always @(posedge clk) begin
        if (count == 0)
            toggle <= ~toggle;
    end
    
    // Continuous output assignment
    assign wave_out = toggle;

endmodule
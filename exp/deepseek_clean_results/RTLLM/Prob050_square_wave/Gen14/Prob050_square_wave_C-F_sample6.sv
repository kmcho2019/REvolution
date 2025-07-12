module square_wave (
    input clk,
    input [7:0] freq,
    output wave_out
);

    reg [6:0] count;
    reg toggle;
    
    // Continuous output assignment
    assign wave_out = (freq == 0) ? 1'b0 : toggle;
    
    // Optimized counter control
    always @(posedge clk) begin
        if (freq == 0) begin
            count <= 7'd0;
            toggle <= 1'b0;
        end else if (count == 0) begin
            count <= freq[6:0] - 1'b1;
            toggle <= ~toggle;
        end else begin
            count <= count - 1'b1;
        end
    end

endmodule
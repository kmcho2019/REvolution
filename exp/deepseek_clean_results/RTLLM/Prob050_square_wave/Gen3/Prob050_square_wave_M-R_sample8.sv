module square_wave (
    input clk,
    input [7:0] freq,
    output wave_out
);

    reg [6:0] count;
    reg toggle_flag;
    
    // Continuous assignment for square wave output
    assign wave_out = toggle_flag;
    
    // Counter control logic
    always @(posedge clk) begin
        if (count == 0) begin
            toggle_flag <= ~toggle_flag;
            count <= freq[6:0];  // Reload counter with frequency value
        end else begin
            count <= count - 1;  // Decrement counter
        end
    end

endmodule
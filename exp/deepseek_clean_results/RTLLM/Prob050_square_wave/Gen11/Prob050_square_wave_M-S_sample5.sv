module square_wave (
    input clk,
    input [7:0] freq,
    output wave_out
);

    reg [7:0] count;
    
    // Output is MSB of counter when freq!=0, else 0
    assign wave_out = (freq == 0) ? 1'b0 : count[7];
    
    always @(posedge clk) begin
        if (freq == 0) begin
            count <= 0;  // Reset counter when freq=0
        end else if (count == freq) begin
            count <= 0;  // Reset at target frequency
        end else begin
            count <= count + 1;  // Simple up-counting
        end
    end

endmodule
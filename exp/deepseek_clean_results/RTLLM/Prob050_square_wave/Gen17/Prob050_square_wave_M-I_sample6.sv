module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

    reg [7:0] count;
    wire terminal_count = (count == freq);
    wire clk_en = terminal_count;  // Clock gating control
    
    always @(posedge clk) begin
        if (terminal_count) begin
            count <= 8'd0;
            wave_out <= ~wave_out;  // Toggle output
        end else begin
            count <= count + 1'b1;
        end
    end

    // Optional: Clock gating cell insertion here
    // (Would be implemented with library cell in physical design)

endmodule
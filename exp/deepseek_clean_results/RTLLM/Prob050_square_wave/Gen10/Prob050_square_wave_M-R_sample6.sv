module square_wave (
    input clk,
    input [7:0] freq,
    output wire wave_out
);

    reg [7:0] count = 0;
    wire [7:0] half_period = freq >> 1;  // freq/2
    
    // Counter logic
    always @(posedge clk) begin
        if (freq == 0)
            count <= 0;
        else if (count == freq - 1)
            count <= 0;
        else
            count <= count + 1;
    end

    // Wave generation - combinational logic
    assign wave_out = (freq == 0) ? 1'b0 : (count < half_period ? 1'b0 : 1'b1);

endmodule
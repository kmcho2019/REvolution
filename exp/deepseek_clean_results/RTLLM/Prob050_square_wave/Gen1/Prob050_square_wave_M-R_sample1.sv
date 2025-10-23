module square_wave (
    input clk,
    input [7:0] freq,
    output wave_out
);

    reg [7:0] count;
    reg toggle;

    // Down-counter logic
    always @(posedge clk) begin
        if (freq == 0) begin
            count <= 0;
        end else if (count == 0) begin
            count <= freq - 1;
            toggle <= ~toggle;
        end else begin
            count <= count - 1;
        end
    end

    // Output assignment
    assign wave_out = toggle;

endmodule
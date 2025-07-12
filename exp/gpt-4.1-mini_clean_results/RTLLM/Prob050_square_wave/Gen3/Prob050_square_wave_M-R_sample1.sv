module square_wave (
    input        clk,
    input  [7:0] freq,
    output reg   wave_out
);

    reg [7:0] count;
    wire toggle;

    // Toggle when count reaches freq - 1 (consider freq=0 edge case)
    assign toggle = (freq != 0) && (count == freq - 1);

    always @(posedge clk) begin
        if (toggle)
            count <= 0;
        else
            count <= count + 1;
    end

    always @(posedge clk) begin
        if (toggle)
            wave_out <= ~wave_out;
    end

endmodule
module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

    reg [7:0] count;
    wire toggle_condition;

    // Toggle when count equals freq (freq!=0); this avoids freq-1 subtraction
    assign toggle_condition = (freq != 0) && (count == freq);

    always @(posedge clk) begin
        if (toggle_condition) begin
            count <= 0;
            wave_out <= ~wave_out;
        end else if (freq == 0) begin
            count <= 0;
            wave_out <= wave_out; // hold steady
        end else begin
            count <= count + 1;
        end
    end

endmodule
module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

    reg [7:0] count;
    wire load = (count == 8'd0) || (freq == 8'd0);
    wire [7:0] next_count = load ? (freq == 8'd0 ? 8'd0 : (freq - 8'd1)) : (count - 8'd1);

    always @(posedge clk) begin
        count <= next_count;
        if (load && (freq != 8'd0)) begin
            wave_out <= ~wave_out;
        end
    end

endmodule
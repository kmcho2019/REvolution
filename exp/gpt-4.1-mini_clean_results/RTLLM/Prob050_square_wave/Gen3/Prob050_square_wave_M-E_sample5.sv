module square_wave (
    input wire clk,
    input wire [7:0] freq,
    output reg wave_out
);

    reg [7:0] count;
    reg toggle_req;

    always @(posedge clk) begin
        if (freq == 0) begin
            count <= 0;
            toggle_req <= 0;
            wave_out <= 0;
        end else begin
            if (count == freq - 1) begin
                count <= 0;
                toggle_req <= 1;
            end else begin
                count <= count + 1;
                toggle_req <= 0;
            end

            if (toggle_req)
                wave_out <= ~wave_out;
        end
    end

endmodule
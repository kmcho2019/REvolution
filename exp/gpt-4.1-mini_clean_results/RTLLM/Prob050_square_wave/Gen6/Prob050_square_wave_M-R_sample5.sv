module square_wave (
    input  wire        clk,
    input  wire        rst_n,     // Active low synchronous reset
    input  wire [7:0]  freq,
    output reg         wave_out
);

    reg [7:0] count;
    wire      enable_count;
    wire      toggle_next;
    reg  [7:0] count_next;

    assign enable_count = (freq != 8'd0);

    // Determine if the next count will cause a toggle
    assign toggle_next = enable_count && ((count + 8'd1) == freq);

    // Next count logic
    always @(*) begin
        if (!enable_count)
            count_next = 8'd0;
        else if (toggle_next)
            count_next = 8'd0;
        else
            count_next = count + 8'd1;
    end

    // Sequential logic for count and wave_out update
    always @(posedge clk) begin
        if (!rst_n) begin
            count    <= 8'd0;
            wave_out <= 1'b0;
        end else begin
            count <= count_next;
            if (toggle_next)
                wave_out <= ~wave_out;
            else
                wave_out <= wave_out;
        end
    end

endmodule
module square_wave (
    input        clk,
    input        rst_n,     // Active low synchronous reset
    input  [7:0] freq,
    output reg   wave_out
);

    reg [7:0] count;
    reg       toggle_req;
    reg [7:0] threshold;

    // Compute threshold (freq - 1) combinationally
    always @(*) begin
        if (freq == 8'd0)
            threshold = 8'd0;
        else
            threshold = freq - 1;
    end

    // Detect when count reaches threshold
    always @(posedge clk) begin
        if (!rst_n)
            toggle_req <= 1'b0;
        else if ((freq != 8'd0) && (count == threshold))
            toggle_req <= 1'b1;
        else
            toggle_req <= 1'b0;
    end

    // Counter increments if enabled and resets on toggle_req or reset
    always @(posedge clk) begin
        if (!rst_n)
            count <= 8'd0;
        else if (freq == 8'd0)
            count <= 8'd0;
        else if (toggle_req)
            count <= 8'd0;
        else
            count <= count + 1'b1;
    end

    // Toggle wave_out on toggle_req
    always @(posedge clk) begin
        if (!rst_n)
            wave_out <= 1'b0;
        else if (toggle_req)
            wave_out <= ~wave_out;
        else
            wave_out <= wave_out;
    end

endmodule
module square_wave (
    input  wire        clk,
    input  wire [7:0]  freq,
    output reg         wave_out
);

    reg [7:0] count;
    wire      terminal_count;

    // Terminal count comparator: true when count reaches freq-1 (unless freq==0)
    assign terminal_count = (freq != 8'd0) && (count == freq - 1);

    // Counter logic: increments up to freq-1 then resets to zero
    always @(posedge clk) begin
        if (freq == 8'd0) begin
            count <= 8'd0;
        end else if (terminal_count) begin
            count <= 8'd0;
        end else begin
            count <= count + 8'd1;
        end
    end

    // Wave output toggle on terminal count
    always @(posedge clk) begin
        if (freq == 8'd0) begin
            wave_out <= wave_out; // Hold current state if freq is zero
        end else if (terminal_count) begin
            wave_out <= ~wave_out;
        end
    end

endmodule
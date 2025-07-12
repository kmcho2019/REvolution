module square_wave (
    input  wire        clk,
    input  wire        rst,       // Active-high synchronous reset
    input  wire [7:0]  freq,
    output reg         wave_out
);

    reg [7:0] count;
    wire      terminal_count;

    // Terminal count when count reaches freq - 1, handle freq=0 separately
    assign terminal_count = (freq != 8'd0) && (count == freq - 1);

    // Counter logic: increment or reset count
    always @(posedge clk) begin
        if (rst) begin
            count <= 8'd0;
        end else if (freq == 8'd0) begin
            count <= 8'd0;  // Hold count steady if freq=0
        end else if (terminal_count) begin
            count <= 8'd0;
        end else begin
            count <= count + 8'd1;
        end
    end

    // Wave output toggle on terminal count
    always @(posedge clk) begin
        if (rst) begin
            wave_out <= 1'b0;
        end else if (freq == 8'd0) begin
            wave_out <= wave_out; // Hold steady if freq=0
        end else if (terminal_count) begin
            wave_out <= ~wave_out;
        end
    end

endmodule
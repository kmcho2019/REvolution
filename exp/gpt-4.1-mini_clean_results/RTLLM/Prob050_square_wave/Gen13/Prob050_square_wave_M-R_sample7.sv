module square_wave (
    input  wire       clk,
    input  wire       rst,       // Active-high synchronous reset
    input  wire [7:0] freq,
    output reg        wave_out
);

    reg [7:0] count;
    reg       toggle_event;
    wire      counting_enabled;

    assign counting_enabled = (freq != 8'd0);

    // Counter block: increments count when enabled, resets on toggle_event or reset
    always @(posedge clk) begin
        if (rst) begin
            count <= 8'd0;
        end else if (counting_enabled) begin
            if (count == (freq - 8'd1)) begin
                count <= 8'd0;
            end else begin
                count <= count + 8'd1;
            end
        end else begin
            count <= 8'd0;
        end
    end

    // toggle_event generation: registered on rollover detection
    always @(posedge clk) begin
        if (rst) begin
            toggle_event <= 1'b0;
        end else begin
            toggle_event <= counting_enabled && (count == (freq - 8'd1));
        end
    end

    // Wave output toggling on toggle_event rising edge
    always @(posedge clk) begin
        if (rst) begin
            wave_out <= 1'b0;
        end else if (toggle_event) begin
            wave_out <= ~wave_out;
        end else begin
            wave_out <= wave_out;
        end
    end

endmodule
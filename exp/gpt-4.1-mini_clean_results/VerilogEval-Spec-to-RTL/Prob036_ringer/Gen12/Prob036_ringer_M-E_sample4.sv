module TopModule (
    input  wire ring,
    input  wire vibrate_mode,
    input  wire clk,
    input  wire reset_n,
    output reg  ringer,
    output reg  motor
);

    // Registered inputs to synchronize and store input signals
    reg ring_reg;
    reg vibrate_mode_reg;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            ring_reg <= 1'b0;
            vibrate_mode_reg <= 1'b0;
        end else begin
            ring_reg <= ring;
            vibrate_mode_reg <= vibrate_mode;
        end
    end

    // Output logic: mutually exclusive ringer and motor based on registered inputs
    always @(*) begin
        if (ring_reg) begin
            if (vibrate_mode_reg) begin
                ringer = 1'b0;
                motor  = 1'b1;
            end else begin
                ringer = 1'b1;
                motor  = 1'b0;
            end
        end else begin
            ringer = 1'b0;
            motor  = 1'b0;
        end
    end

endmodule
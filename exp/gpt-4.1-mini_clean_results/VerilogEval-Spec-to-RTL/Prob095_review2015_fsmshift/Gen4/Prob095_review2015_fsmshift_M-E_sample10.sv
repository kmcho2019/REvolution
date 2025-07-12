module TopModule (
    input  wire clk,
    input  wire reset,
    output reg  shift_ena
);

    reg [2:0] enable_counter;

    always @(posedge clk) begin
        if (reset) begin
            enable_counter <= 3'd4;     // Enable for 4 cycles after reset
        end else if (enable_counter != 0) begin
            enable_counter <= enable_counter - 1;
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            shift_ena <= 1'b1;
        end else begin
            shift_ena <= (enable_counter != 0);
        end
    end

endmodule
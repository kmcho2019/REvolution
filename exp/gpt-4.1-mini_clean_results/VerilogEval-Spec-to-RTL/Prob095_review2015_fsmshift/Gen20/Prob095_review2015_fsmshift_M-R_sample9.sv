module TopModule (
    input  wire clk,
    input  wire reset,    // synchronous active high
    output wire shift_ena
);

    reg [2:0] ena_count;

    // On reset, load counter with 4 (4 cycles including current)
    // Otherwise, count down until zero
    always @(posedge clk) begin
        if (reset) begin
            ena_count <= 3'd4;
        end else if (ena_count != 0) begin
            ena_count <= ena_count - 1;
        end else begin
            ena_count <= ena_count;  // Hold at zero
        end
    end

    assign shift_ena = (ena_count != 0);

endmodule
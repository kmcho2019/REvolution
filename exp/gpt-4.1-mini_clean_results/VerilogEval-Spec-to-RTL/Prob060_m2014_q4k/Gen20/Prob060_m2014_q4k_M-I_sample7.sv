module TopModule (
    input  wire clk,
    input  wire resetn,  // asynchronous active-low reset input (external)
    input  wire in,
    output wire out
);
    reg [3:0] shift_reg;
    reg resetn_sync;

    // Synchronize resetn asynchronously asserted to clk domain
    // This avoids metastability and enables safe asynchronous reset deassertion
    always @(posedge clk or negedge resetn) begin
        if (~resetn)
            resetn_sync <= 1'b0;
        else
            resetn_sync <= 1'b1;
    end

    always @(posedge clk) begin
        if (~resetn_sync)
            shift_reg <= 4'b0000;
        else
            shift_reg <= {shift_reg[2:0], in};
    end

    assign out = shift_reg[3];
endmodule
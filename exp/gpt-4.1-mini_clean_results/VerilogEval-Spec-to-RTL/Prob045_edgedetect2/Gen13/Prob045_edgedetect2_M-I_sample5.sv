module TopModule (
    input        clk,
    input  [7:0] in,
    output [7:0] anyedge
);

    reg [7:0] prev_in;
    reg [7:0] anyedge_reg;

    // On every clock, sample previous input and store edge detection
    always @(posedge clk) begin
        anyedge_reg <= in ^ prev_in; // Edge detected on previous cycle's transition
        prev_in <= in;               // Store current input for next cycle comparison
    end

    assign anyedge = anyedge_reg;

endmodule
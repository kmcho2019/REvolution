module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    reg [7:0] prev_in;
    wire [7:0] diff;
    wire update_enable;

    assign diff = in ^ prev_in;
    assign update_enable = |diff; // Enable update only if any bit changed

    always @(posedge clk) begin
        if (update_enable) begin
            prev_in <= in;
            anyedge <= diff;
        end else begin
            // Hold previous values to prevent unnecessary toggling
            prev_in <= prev_in;
            anyedge <= 8'b0;
        end
    end
endmodule
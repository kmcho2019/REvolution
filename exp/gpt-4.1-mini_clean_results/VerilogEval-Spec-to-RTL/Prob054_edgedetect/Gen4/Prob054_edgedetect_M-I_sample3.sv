module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;
    wire      input_changed;

    assign input_changed = (in != prev_in);

    always @(posedge clk) begin
        if (input_changed) begin
            pedge   <= (~prev_in) & in;
            prev_in <= in;
        end
        else begin
            pedge   <= 0;
        end
    end

endmodule
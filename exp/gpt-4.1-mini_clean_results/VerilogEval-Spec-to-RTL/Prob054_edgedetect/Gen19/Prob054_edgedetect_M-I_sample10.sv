module TopModule (
    input          clk,
    input   [7:0]  in,
    output  reg [7:0] pedge
);

    reg [7:0] prev_in;

    always @(posedge clk) begin
        // Update prev_in only if input changes to reduce toggling power
        if (in != prev_in) begin
            pedge <= (~prev_in) & in;
            prev_in <= in;
        end else begin
            pedge <= 0;
        end
    end

endmodule
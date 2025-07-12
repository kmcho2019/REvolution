module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;
    wire update_en;

    // Enable update only when input changes (any bit different from previous)
    assign update_en = |(prev_in ^ in);

    always @(posedge clk) begin
        if (update_en) begin
            pedge   <= (~prev_in) & in; // register detected 0->1 transitions
            prev_in <= in;              // store current input for next cycle comparison
        end else begin
            pedge <= 0; // output zero if input stable, no edge
        end
    end

endmodule
module TopModule (
    input             clk,
    input      [7:0]  in,
    output reg [7:0]  anyedge
);

    reg [7:0] prev_in;
    wire      input_changed;

    assign input_changed = |(in ^ prev_in); // detect if any bit changed

    always @(posedge clk) begin
        anyedge <= in ^ prev_in;
        if (input_changed)
            prev_in <= in;
        else
            prev_in <= prev_in; // hold previous value to reduce toggling
    end

endmodule
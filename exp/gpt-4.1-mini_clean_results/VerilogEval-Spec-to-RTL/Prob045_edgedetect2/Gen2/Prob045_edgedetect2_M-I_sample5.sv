module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;
    wire [7:0] edges;

    assign edges = prev_in ^ in;

    always @(posedge clk) begin
        prev_in <= in;
        if (|edges) // update anyedge only if any bit changed
            anyedge <= edges;
        else
            anyedge <= 0;  // clear anyedge if no edge detected
    end

endmodule
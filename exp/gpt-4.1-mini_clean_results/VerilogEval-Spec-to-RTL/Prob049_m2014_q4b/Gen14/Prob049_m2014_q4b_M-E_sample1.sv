module DFF_AsyncReset (
    input  clk,
    input  ar,    // asynchronous active-high reset
    input  d,
    output reg q
);

    always @(posedge clk or posedge ar) begin
        if (ar) 
            q <= 1'b0;      // asynchronous reset
        else 
            q <= d;         // capture data on clock edge
    end

endmodule

module TopModule (
    input  clk,
    input  ar,
    input  d,
    output q
);
    // Instantiate the D flip-flop with async reset
    DFF_AsyncReset dff_inst (
        .clk(clk),
        .ar(ar),
        .d(d),
        .q(q)
    );

endmodule
module DFF_Core (
    input  clk,
    input  d,
    output reg q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule

module Reset_Logic (
    input  clk,
    input  d,
    input  r,
    output q
);
    wire core_out;
    
    DFF_Core dff_core (
        .clk(clk),
        .d(d),
        .q(core_out)
    );
    
    // Output gating for reset
    assign q = r ? 1'b0 : core_out;
endmodule

module TopModule (
    input  clk,
    input  d,
    input  r,
    output q
);
    Reset_Logic reset_logic (
        .clk(clk),
        .d(d),
        .r(r),
        .q(q)
    );
endmodule
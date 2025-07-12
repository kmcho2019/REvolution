`default_nettype none

module ClockGatedDFF(
    input wire clk,
    input wire d,
    output wire q
);
    reg q_reg;
    wire data_changed;
    wire gated_clk;
    
    // Detect when input data differs from current output
    assign data_changed = d ^ q;
    
    // Gate the clock with the change detector
    assign gated_clk = clk & data_changed;
    
    always @(posedge gated_clk) begin
        q_reg <= d;
    end
    
    assign q = q_reg;
endmodule

module TopModule(
    input wire clk,
    input wire d,
    output wire q
);
    ClockGatedDFF dff_inst(
        .clk(clk),
        .d(d),
        .q(q)
    );
endmodule

`default_nettype wire
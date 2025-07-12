module TopModule (
    output one
);
    // Create a minimal ring oscillator (3 inverters)
    wire osc_out;
    wire inv1_out, inv2_out;
    
    // The oscillator is never enabled (tied to 0)
    // so it won't actually oscillate
    not inv1(inv1_out, 1'b0);
    not inv2(inv2_out, inv1_out);
    not inv3(osc_out, inv2_out);
    
    // D-flipflop initialized to 1
    reg dff_out = 1'b1;
    always @(posedge osc_out) begin
        dff_out <= osc_out;
    end
    
    assign one = dff_out;
endmodule
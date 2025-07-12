module TopModule(output one);
    // Internal ring oscillator (3 inverters)
    wire osc_out;
    reg a, b, c;
    
    initial begin
        a = 0;
        b = 1;
        c = 0;
    end
    
    always begin
        #1 a <= ~c;
        #1 b <= ~a;
        #1 c <= ~b;
    end
    
    assign osc_out = c;
    
    // D flip-flop to sample the oscillator
    reg dff_out;
    always @(posedge osc_out) begin
        dff_out <= 1'b1;
    end
    
    assign one = dff_out;
endmodule
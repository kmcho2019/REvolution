module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    // Register to store previous inputs for change detection
    reg [99:0] prev_a, prev_b;
    reg prev_sel;
    
    // Activity detection
    wire inputs_changed = (a != prev_a) || (b != prev_b) || (sel != prev_sel);
    
    // Output assignment with activity control
    assign out = inputs_changed ? (sel ? b : a) : out;
    
    // Update previous values
    always @(*) begin
        prev_a = a;
        prev_b = b;
        prev_sel = sel;
    end

endmodule
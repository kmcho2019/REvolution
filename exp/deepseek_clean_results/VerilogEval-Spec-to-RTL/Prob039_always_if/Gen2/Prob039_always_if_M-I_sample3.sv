module TopModule (
    input  wire a,       // First input
    input  wire b,       // Second input
    input  wire sel_b1,  // First select signal
    input  wire sel_b2,  // Second select signal
    output wire out_assign,  // Output from continuous assignment
    output reg  out_always   // Output from procedural block
);

    // Continuous assignment implementation:
    // Select b when both sel_b1 and sel_b2 are true, else select a
    assign out_assign = (sel_b1 & sel_b2) ? b : a;

    // Procedural implementation with identical functionality:
    // Uses combinational always block with explicit sensitivity list
    always @(a or b or sel_b1 or sel_b2) begin
        if (sel_b1 & sel_b2) begin
            out_always = b;
        end else begin
            out_always = a;
        end
    end

endmodule
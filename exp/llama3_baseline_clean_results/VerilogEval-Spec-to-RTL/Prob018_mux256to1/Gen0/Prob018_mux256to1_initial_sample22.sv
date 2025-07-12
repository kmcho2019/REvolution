module TopModule(
    input  [255:0] in,
    input  [7:0] sel,
    output out
);

always @(*)
begin
    case (sel)
        8'd0: out = in[0];
        8'd1: out = in[1];
        8'd2: out = in[2];
        // ... (this would get tedious, a better way is to use a more compact syntax)
        // Instead, we'll use a loop to generate the cases
        default: out = 1'bx; // default to unknown if sel is out of range
    endcase
end

// However, using a case statement with 256 cases is impractical.
// A better approach is to use the sel as an index directly
// Unfortunately, Verilog doesn't allow using a variable as an index
// But we can use a for loop in a generate block to create a large case statement
// Here's the improved version:
module TopModuleImproved(
    input  [255:0] in,
    input  [7:0] sel,
    output out
);
integer i;
always @(*)
begin
    out = 1'bx; // default to unknown
    for (i = 0; i < 256; i = i + 1)
    begin
        if (sel == i)
        begin
            out = in[i];
        end
    end
end
// Or, using a more compact and idiomatic way:
module TopModuleBest(
    input  [255:0] in,
    input  [7:0] sel,
    output out
);
assign out = in[sel];

endmodule
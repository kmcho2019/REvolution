// D flip-flop module with synthesis attributes to gently preserve register for debug/physical constraints.
// Attributes are vendor-neutral where possible and accompanied by comments for tool-specific tuning.
module DFF (
    input  wire clk,
    input  wire d,
    output reg  q
);
    // syn_preserve: encourages synthesis tools to keep this register
    // keep: stronger hint to prevent optimization removal; comment out if power/area critical
    (* syn_preserve = "true" *)
    (* keep = "true" *) 
    always @(posedge clk) begin
        q <= d;
    end
endmodule

// Top-level module instantiates DFF directly with clean interface.
// No additional logic or wiring to keep the design minimal and clear.
module TopModule (
    input  wire clk,
    input  wire d,
    output wire q
);
    DFF dff_inst (
        .clk(clk),
        .d(d),
        .q(q)
    );
endmodule
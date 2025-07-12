module MuxCell #(
    parameter USE_ASSIGN = 1
)(
    input  wire a,
    input  wire b,
    input  wire sel,
    output wire y
);
    generate
        if (USE_ASSIGN) begin : gen_assign
            // Continuous assignment mux
            assign y = sel ? b : a;
        end else begin : gen_none
            // For procedural usage, leave y unconnected here
            // Driven externally in always block
            // Tie y to 0 to avoid undriven warning (optional)
            assign y = 1'b0;
        end
    endgenerate
endmodule

module TopModule(
    input  wire a,
    input  wire b,
    input  wire sel_b1,
    input  wire sel_b2,
    output wire out_assign,
    output reg  out_always
);
    wire sel_combined;
    assign sel_combined = sel_b1 & sel_b2;

    // Output from assign-based MuxCell (USE_ASSIGN=1)
    wire assign_out;
    MuxCell #(.USE_ASSIGN(1)) mux_assign_inst (
        .a(a),
        .b(b),
        .sel(sel_combined),
        .y(assign_out)
    );
    assign out_assign = assign_out;

    // Output from procedural MuxCell (USE_ASSIGN=0)
    wire proc_mux_dummy; // unused output
    MuxCell #(.USE_ASSIGN(0)) mux_proc_inst (
        .a(a),
        .b(b),
        .sel(sel_combined),
        .y(proc_mux_dummy)
    );

    // Procedural always block mux logic
    always @(*) begin
        if (sel_combined)
            out_always = b;
        else
            out_always = a;
    end

endmodule
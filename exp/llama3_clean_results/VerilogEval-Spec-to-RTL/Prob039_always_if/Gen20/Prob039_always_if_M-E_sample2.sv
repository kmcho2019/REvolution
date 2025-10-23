// Define a SystemVerilog interface for the multiplexer module ports
interface mux_if;
    logic a, b, sel_b1, sel_b2, out;
endinterface

// Define a parameterizable multiplexer module
module param_mux #(
    parameter int WIDTH = 1
)(
    mux_if.mux_if mux_if
);
    always_comb begin
        // Conditional logic for selecting between a and b based on sel_b1 and sel_b2
        mux_if.out = (mux_if.sel_b1 && mux_if.sel_b2) ? mux_if.b : mux_if.a;
    end
endmodule

// Define the TopModule, instantiating the parameterizable multiplexer module twice
module TopModule(
    input  logic a,
    input  logic b,
    input  logic sel_b1,
    input  logic sel_b2,
    output logic out_assign,
    output logic out_always
);
    // Instantiate the first multiplexer for out_assign
    mux_if mux_if_assign();
    param_mux #(.WIDTH(1)) mux_assign(
        .mux_if(mux_if_assign)
    );
    assign mux_if_assign.a = a;
    assign mux_if_assign.b = b;
    assign mux_if_assign.sel_b1 = sel_b1;
    assign mux_if_assign.sel_b2 = sel_b2;
    assign out_assign = mux_if_assign.out;

    // Instantiate the second multiplexer for out_always
    mux_if mux_if_always();
    param_mux #(.WIDTH(1)) mux_always(
        .mux_if(mux_if_always)
    );
    assign mux_if_always.a = a;
    assign mux_if_always.b = b;
    assign mux_if_always.sel_b1 = sel_b1;
    assign mux_if_always.sel_b2 = sel_b2;
    assign out_always = mux_if_always.out;
endmodule
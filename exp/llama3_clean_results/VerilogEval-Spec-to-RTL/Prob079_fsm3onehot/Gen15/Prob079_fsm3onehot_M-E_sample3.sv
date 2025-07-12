module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // One-hot state encoding defined as local parameters for modularity and readability
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;

    // State transition logic using multiplexers for modularity and potential area reduction
    wire [3:0] ns_A = (in) ? B : A;
    wire [3:0] ns_B = (in) ? B : C;
    wire [3:0] ns_C = (in) ? D : A;
    wire [3:0] ns_D = (in) ? B : C;

    assign next_state = (state == A) ? ns_A :
                        (state == B) ? ns_B :
                        (state == C) ? ns_C :
                        (state == D) ? ns_D : 4'bxxxx;

    // Output logic using a simple multiplexer for potential area and power reduction
    assign out = (state == D) ? 1'b1 : 1'b0;

    // Alternative approach for output logic using a multiplexer (commented out for demonstration)
    // wire out_A = 1'b0;
    // wire out_B = 1'b0;
    // wire out_C = 1'b0;
    // wire out_D = 1'b1;
    // assign out = (state == A) ? out_A :
    //              (state == B) ? out_B :
    //              (state == C) ? out_C :
    //              (state == D) ? out_D : 1'b0;

endmodule
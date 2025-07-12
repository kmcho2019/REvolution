module TopModule(
    input  wire a,
    input  wire b,
    input  wire sel_b1,
    input  wire sel_b2,
    output wire out_assign,
    output reg  out_always
);

    wire sel_final;
    wire selected_data;

    // Combine select signals
    assign sel_final = sel_b1 & sel_b2;

    // Select data wire: mux output computed once
    assign selected_data = sel_final ? b : a;

    // Continuous assignment output directly from selected_data
    assign out_assign = selected_data;

    // Procedural output assigned in combinational always block
    always @(*) begin
        out_always = selected_data;
    end

endmodule
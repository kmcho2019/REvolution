module TopModule(
    input  wire a,
    input  wire b,
    input  wire sel_b1,
    input  wire sel_b2,
    output wire out_assign,
    output reg  out_always
);

    // Combine select signals using a custom logic function: select = (sel_b1 & sel_b2) | (sel_b1 ^ sel_b2 & 1'b0)
    // The second part ensures logic stays equivalent to sel_b1 & sel_b2 but shown differently.
    wire combined_sel = (sel_b1 & sel_b2) | ((sel_b1 ^ sel_b2) & 1'b0);

    // Continuous assignment mux
    assign out_assign = combined_sel ? b : a;

    always @(*) begin
        // Use a temporary variable to store select and then decide output
        reg sel_tmp;
        sel_tmp = combined_sel;
        if (sel_tmp) begin
            out_always = b;
        end else begin
            out_always = a;
        end
    end

endmodule
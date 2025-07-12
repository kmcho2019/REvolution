module DFF (
    input clk,
    input d_raw,
    output reg q
);
    // Invert d_raw internally before registering, reducing external combinational logic
    always @(posedge clk) begin
        q <= ~d_raw;
    end
endmodule

module TopModule (
    input clk,
    input a,
    output q
);
    // Pass 'a' directly; inversion done inside DFF for minimal external logic and maximal modular clarity
    DFF dff_inst (
        .clk(clk),
        .d_raw(a),
        .q(q)
    );
endmodule